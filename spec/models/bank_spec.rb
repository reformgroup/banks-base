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

require 'spec_helper'

RSpec.describe BankUser, type: :model do
  
  before do 
    @bank = build(:bank)
  end

  subject { @bank }
   
  it { should respond_to(:name) }
  it { should respond_to(:short_name) }
  it { should respond_to(:website) }
  
  it { should be_valid }
  
  context "when name is invalid" do
    it "should be invalid" do
      name = ['a', '123', '<as?', 'a.a', 'a,a', 'a_a']
      name.each do |i|
        @bank.name = i
        expect(@bank).not_to be_valid
      end
    end
  end
  
  context "when name is valid" do
    it "should be valid" do
      name = ['MB', 'My-Bank', 'Bank', 'My Bank']
      name.each do |i|
        @bank.name = i
        expect(@bank).to be_valid
      end
    end
  end

  context "when short name is invalid" do
    it "should be invalid" do
      name = ['a', '123', '<as?', 'a.a', 'a,a', 'a_a']
      name.each do |i|
        @bank.short_name = i
        expect(@bank).not_to be_valid
      end
    end
  end
  
  context "when short name is valid" do
    it "should be valid" do
      name = ['MB', 'My-Bank', 'Bank', 'My Bank']
      name.each do |i|
        @bank.short_name = i
        expect(@bank).to be_valid
      end
    end
  end

  context "when website is invalid" do
    it "should be invalid" do
      name = ['htt://www.foobar.com/', 'httpss://www.foobar.com/', 'http:/foobar.com/', 'http://foobar.com//', 
              '//foobar.com//', 'ww.foobar.com', 'foobar.', 'foo-bar com', ' foobar.com', 'foobar.com ',
              'http:/foobar.com/?lang=en', 'фттп://пример.рф/', 'http://foo?bar.com/', 'http://foo<>bar.com/', 
              'http://foo/bar.com/']
      name.each do |i|
        @bank.website = i
        expect(@bank).not_to be_valid
      end
    end
  end
  
  context "when website is valid" do
    it "should be valid" do
      name = ['http://www.foobar.com/', 'https://www.foobar.com/', 'http://foobar.com/', 'http://foobar.com', 
              'www.foobar.com', 'foobar.com', 'foo-bar.com', 'FOObar.COM', 'пример.рф']
      name.each do |i|
        @bank.website = i
        expect(@bank).to be_valid
      end
    end
  end

  context "website with mixed case" do
    let(:mixed_case_website) { "hTTp://WWW.fooBAR.COM/" }

    it "should be saved as all lower-case" do
      @bank.website = mixed_case_website
      @bank.save
      expect(@bank.reload.website).to eq mixed_case_website.downcase
    end
  end

  context "when website is already taken" do
    before do
      bank_with_same_website = @bank.dup
      bank_with_same_website.website = @bank.website.upcase
      bank_with_same_website.save
    end

    it { should_not be_valid }
  end
end
