class AddPoidsIdealToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :poids_ideal, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :users, :poids_ideal
  end
end
