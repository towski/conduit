class CreateConduits < ActiveRecord::Migration
  def self.up
    create_table :conduits do |t|
      t.string :url
      t.string :key
      t.timestamps
    end
  end

  def self.down
    drop_table :conduits
  end
end
