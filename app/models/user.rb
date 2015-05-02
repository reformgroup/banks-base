# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  last_name           :string           not null
#  first_name          :string           not null
#  middle_name         :string
#  email               :string           not null
#  gender              :integer          not null
#  birth_date          :date             not null
#  password_digest     :string           not null
#  remember_digest     :string
#  role                :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#

class User < ActiveRecord::Base
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_NAME_REGEX  = /\A[[:alpha:]]+[[:alpha:] \-']*[[:alpha:]]+\z/i
  AVATAR_PATH       = "/system/users/avatars/:class/:attachment/:id_partition/:style"
  
  attr_accessor :remember_token
  
  has_many :bank_users
  has_many :banks, through: :bank_users
  has_secure_password
  has_attached_file :avatar, 
    { 
      styles: { original: "120x120#", medium: "50x50#", thumb: "40x40#" }, 
      default_url: "/images/users/avatars/:style/missing.png",
      url: "#{AVATAR_PATH}/:hash.:extension",
      path: ":rails_root/public#{AVATAR_PATH}/:hash.:extension",
      hash_data: AVATAR_PATH,
      hash_secret: "A13S4Dtu54y5g63d363sa3JH30Ff9dyH56lih6JguyHY736crtyf45dx"
    }
     
  validates :last_name, presence: true, length: { maximum: 50 }, format: { with: VALID_NAME_REGEX }
  validates :first_name, presence: true, length: { maximum: 50 }, format: { with: VALID_NAME_REGEX }
  validates :middle_name, presence: true, length: { maximum: 50 }, format: { with: VALID_NAME_REGEX }, if: :middle_name
  validates :gender, presence: true, length: { maximum: 6 }
  validates_date :birth_date, presence: true, on_or_before: lambda { User.not_younger }, on_or_after: lambda { User.not_older }
  validates :email, presence: true, length: { maximum: 50 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, if: :password
  validates :password_confirmation, presence: true, if: :password_confirmation
  validates :role, presence: true, if: :role
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  before_save { email.downcase! }
  before_save :set_name
  after_initialize :set_default_role, if: :new_record?
    
  enum gender: [:male, :female, :other]
  enum role: [:superadmin, :admin, :bank_admin, :bank_user, :user]
  
  class << self
    
    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
    
    # Users can not be older than this date
    def not_older
      108.years.ago
    end
    
    # Users can not be younger than this date
    def not_younger
      18.years.ago
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # Returns short user name like "Fred S."
  def short_name
    "#{first_name} #{last_name[0]}."
  end
  
  # Returns full user name like "Fred Smitt"
  def full_name(options = {})
    name = "#{first_name}"
    name << " #{middle_name}" if options[:middle_name] && middle_name
    options[:last_name_first] ? "#{last_name} #{name}" : "#{name} #{last_name}"
  end
  
  private
  
  def set_default_role
    self.role ||= :user
  end
  
  def set_name
    self.first_name = normalize_name(self.first_name)
    self.last_name = normalize_name(self.last_name)
  end

  def normalize_name(name)
    name.gsub!(/^[ -]*|[ -]*$/, "")
    name.gsub!(/[ ]*[-]{2,}[ ]*/, "-")
    name.gsub!(/[ ]{2,}/, " ")
    name.gsub!(/[[:alpha:]]+/i) { |s| s.capitalize }
  end
end 
