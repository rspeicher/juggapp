class CreateServers < ActiveRecord::Migration
  def self.up
    create_table :servers do |t|
      t.string :region, :null => false, :default => 'us'
      t.string :name, :null => false
      t.string :ruleset
    end

    add_index :servers, :name
  end

  def self.down
    drop_table :servers
  end
end
