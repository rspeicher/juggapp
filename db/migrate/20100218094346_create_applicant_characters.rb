class CreateApplicantCharacters < ActiveRecord::Migration
  def self.up
    create_table :applicant_characters do |t|
      t.references :applicant

      t.references :server, :null => false
      t.string :current_name, :null => false
      t.string :wow_class, :null => false
      t.string :current_race
      t.string :armory_link, :null => false
      t.boolean :original_owner
      t.text :previous_guilds
      t.text :reasons_for_leaving
      t.text :pve_experience
      t.text :pvp_experience
      t.string :screenshot_link
    end

    add_index :applicant_characters, :applicant_id
    add_index :applicant_characters, :current_name
  end

  def self.down
    drop_table :applicant_characters
  end
end
