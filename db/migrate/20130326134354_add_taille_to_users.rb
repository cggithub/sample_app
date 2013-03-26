class AddTailleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :taille, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :users, :taille
  end
end
