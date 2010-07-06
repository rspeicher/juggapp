class AddSpecsToApplicant < ActiveRecord::Migration
  def self.up
    add_column :applicants, :primary_spec, :string
    add_column :applicants, :secondary_spec, :text
  end

  def self.down
    remove_column :applicants, :secondary_spec
    remove_column :applicants, :primary_spec
  end
end
