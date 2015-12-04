class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :name, null: false, unique: true
      t.string :short_name
      t.string :website, unique: true
      
      t.timestamps null: false
    end
    
    add_index :banks, [:name, :website]
  end
end
