class RemoveOnceFromPeriodicRoutines < ActiveRecord::Migration
  def change
    remove_column :periodic_routines, :once, :boolean
  end
end
