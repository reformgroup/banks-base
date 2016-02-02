class CreateBankUsers < ActiveRecord::Migration
  def change
    create_table :bank_users do |t|
      t.references :bank, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
      t.userstamps index: true
    end
  end
end
