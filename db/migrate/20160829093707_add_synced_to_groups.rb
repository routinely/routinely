class AddSyncedToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :synced, :boolean, default: true

    Group.find_each { |g| g.update(synced: true) }

    change_column_null :groups, :synced, false
  end
end
