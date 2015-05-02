# == Schema Information
#
# Table name: bank_users
#
#  id         :integer          not null, primary key
#  bank_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BankUser < ActiveRecord::Base
  
  belongs_to :bank
  belongs_to :user
  accepts_nested_attributes_for :user
end
