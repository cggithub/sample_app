class AddPoidsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :poids, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :users, :poids
  end
end
