class AddPrivateConduits < ActiveRecord::Migration
  def self.up
  	add_column :conduits, :private, :boolean
  end

  def self.down
  	remove_column :conduits, :private
  end
end
