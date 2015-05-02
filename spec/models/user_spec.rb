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

require 'spec_helper'

RSpec.describe User, :type => :model do
  
  before { @user = build(:user) }

  subject { @user }
  
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:gender) }
  it { should respond_to(:birth_date) }
  
  it { should be_valid }

  context "when first name format is invalid" do
    it "should be invalid" do
      name = %w[foo123 ,foo foo,bar]
      name.each do |i|
        @user.first_name = i
        expect(@user).not_to be_valid
      end
    end
  end
  
  context "when first name format is valid" do
    it "should be valid" do
      name = %w[Foo fOO foo Foo-Bar Николай]
      name.each do |i|
        @user.first_name = i
        expect(@user).to be_valid
      end
    end
  end

  context "when last name format is invalid" do
    it "should be invalid" do
      name = %w[foo123 ,foo foo,bar]
      name.each do |i|
        @user.last_name = i
        expect(@user).not_to be_valid
      end
    end
  end
  
  context "when last name format is valid" do
    it "should be valid" do
      name = %w[Foo fOO foo Foo-Bar Александров]
      name.each do |i|
        @user.last_name = i
        expect(@user).to be_valid
      end
    end
  end

  context "when birth date format is invalid" do
    it "should be valid" do
      dates = %w[deew-12-12 0000-00-00 FooBar]
      dates.each do |i|
        @user.email = i
        expect(@user).not_to be_valid
      end
    end
  end

  context "when birth date format is valid" do
    before { @user.email = 18.years.ago }
    it { should_not be_valid }
  end

  context "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end
  
  context "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  context "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end
  
  context "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  context "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end
  
  context "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  context "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  context "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    context "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    context "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be false }
    end
  end
end
