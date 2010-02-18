class CreateApplicantSystems < ActiveRecord::Migration
  def self.up
    create_table :applicant_systems do |t|
      t.references :applicant

      t.string :connection_type
      t.boolean :has_microphone
      t.boolean :has_ventrilo
      t.boolean :uses_ventrilo
    end

    add_index :applicant_systems, :applicant_id
  end

  def self.down
    remove_index :applicant_systems, :applicant_id
    drop_table :applicant_systems
  end
end
