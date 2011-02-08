class AddLogsToApplicant < ActiveRecord::Migration
  def self.up
    add_column :applicants, :logs, :text
  end

  def self.down
    remove_column :applicants, :logs
  end
end
