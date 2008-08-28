class AddUserId < ActiveRecord::Migration
  def self.up
  	add_column :conduits, :user_id, :integer
  end

  def self.down
  	remove_column :conduits, :user_id
  end
end
