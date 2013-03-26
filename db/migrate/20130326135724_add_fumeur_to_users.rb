class AddFumeurToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fumeur, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :users, :fumeur
  end
end
