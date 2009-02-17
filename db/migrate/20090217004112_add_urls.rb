class AddUrls < ActiveRecord::Migration
  def self.up
		create_table :urls do |t|
			t.text :url
			t.timestamps
			t.integer :conduit_id
			t.integer :user_id
		end
  end

  def self.down
		drop_table :urls
  end
end
