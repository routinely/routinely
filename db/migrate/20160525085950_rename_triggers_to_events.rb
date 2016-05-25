class RenameTriggersToEvents < ActiveRecord::Migration
  def change
    rename_table :triggers, :events
    rename_column :routines, :triggers_count, :events_count
  end
end
