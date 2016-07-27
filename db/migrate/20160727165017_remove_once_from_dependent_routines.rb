class RemoveOnceFromDependentRoutines < ActiveRecord::Migration
  def change
    remove_column :dependent_routines, :once, :boolean
  end
end
