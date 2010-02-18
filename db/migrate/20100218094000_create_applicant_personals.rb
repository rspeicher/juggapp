class CreateApplicantPersonals < ActiveRecord::Migration
  def self.up
    create_table :applicant_personals do |t|
      t.references :applicant

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
    end

    add_index :applicant_personals, :applicant_id
  end

  def self.down
    drop_table :applicant_personals
  end
end
