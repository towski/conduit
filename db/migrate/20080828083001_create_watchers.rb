class CreateWatchers < ActiveRecord::Migration
  def self.up
  	create_table(:conduits_users, :id => false) do |t|
		t.integer :user_id
		t.integer :conduit_id
		t.timestamps
		end
  end

  def self.down
  	drop_table(:conduits_users)
  end
end
