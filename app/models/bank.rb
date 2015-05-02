# == Schema Information
#
# Table name: banks
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  short_name :string
#  website    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Bank < ActiveRecord::Base
  
  VALID_NAME_REGEX = /\A[[:alpha:]]+[[:alpha:] \-']*[[:alpha:]]+\z/i
  VALID_WEBSITE_REGEX = /\A((http|https):\/\/)?(www.)?[[:alpha:]0-9][[:alpha:]0-9\-]*[[:alpha:]0-9]\.[[:alpha:]]+\/?\z/i
  
  has_many :bank_users
  has_many :users, through: :bank_users
  accepts_nested_attributes_for :bank_users
  
  validates :name, presence: true, length: { maximum: 50 }, format: { with: VALID_NAME_REGEX }
  validates :short_name, presence: true, length: { maximum: 50 }, format: { with: VALID_NAME_REGEX }, :if => :short_name
  validates :website, presence: true, length: { maximum: 50 }, format: { with: VALID_WEBSITE_REGEX }, uniqueness: { case_sensitive: false }
  validates_associated :users

  before_validation :normalize_name
 
  private
  
  def normalize_name
    unless self.website.blank?
      self.website.downcase!
      #self.website = "http://" + self.website unless self.website =~ /\A((http|https):\/\/)/i
      #self.website = self.website + "/" unless self.website[-1,1] == "/"
    end
  end
end
