class AddEventCountsToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :starts_count, :integer, null: false, default: 0
    add_column :versions, :triggers_count, :integer, null: false, default: 0
  end
end
