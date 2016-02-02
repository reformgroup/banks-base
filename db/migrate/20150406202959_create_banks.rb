class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :name, index: true, null: false, unique: true
      t.string :short_name
      t.string :website, index: true, unique: true
      
      t.timestamps null: false
      t.userstamps index: true
    end
  end
end
