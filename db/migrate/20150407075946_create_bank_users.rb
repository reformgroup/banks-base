class CreateBankUsers < ActiveRecord::Migration
  def change
    create_table :bank_users do |t|
      t.references :bank, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :bank_users, :banks
    add_foreign_key :bank_users, :users
  end
end
