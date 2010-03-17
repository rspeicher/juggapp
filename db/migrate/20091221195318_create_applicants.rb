class CreateApplicants < ActiveRecord::Migration
  def self.up
    create_table :applicants do |t|
      t.string :status, :default => 'pending'
      t.integer :user_id
      t.integer :topic_id

      # Personal
      t.string :name
      t.integer :age
      t.string :time_zone
      %w(sunday monday tuesday wednesday thursday friday saturday).each do |day|
        t.time "start_#{day}"
        t.time "end_#{day}"
      end
      t.text :known_members
      t.text :future_commitments
      t.text :reasons_for_joining

      # Character
      t.references :server, :null => false
      t.string :character_name, :null => false
      t.string :character_class, :null => false
      t.string :character_race
      t.string :armory_link, :null => false
      t.boolean :original_owner
      t.text :previous_guilds
      t.text :reasons_for_leaving
      t.text :pve_experience
      t.text :pvp_experience
      t.string :screenshot_link

      # System
      t.string :connection_type
      t.boolean :has_microphone
      t.boolean :has_ventrilo
      t.boolean :uses_ventrilo

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
