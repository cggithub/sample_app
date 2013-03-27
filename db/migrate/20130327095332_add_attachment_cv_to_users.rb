class AddAttachmentCvToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :cv
    end
  end

  def self.down
    drop_attached_file :users, :cv
  end
end
