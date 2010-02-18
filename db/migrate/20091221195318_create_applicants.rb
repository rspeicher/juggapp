class CreateApplicants < ActiveRecord::Migration
  def self.up
    create_table :applicants do |t|
      t.string :status, :default => 'new'
      t.integer :user_id
      t.integer :topic_id
      t.text :comments
      t.timestamps
    end

    add_index :applicants, :user_id
    add_index :applicants, :topic_id
  end

  def self.down
    drop_table :applicants
  end
end
