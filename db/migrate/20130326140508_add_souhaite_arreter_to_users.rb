class AddSouhaiteArreterToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :souhaite_arreter, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :users, :souhaite_arreter
  end
end
