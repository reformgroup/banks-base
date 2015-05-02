class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :middle_name
      t.string :email, null: false, unique: true
      t.integer :gender, null: false
      t.date :birth_date, null: false
      t.string :password_digest, null: false
      t.string :remember_digest
      t.integer :role, null: false
      t.attachment :avatar
      
      t.timestamps null: false
    end
    
    add_index :users, [:email]
  end
end
