class AddTriggersCountToRoutines < ActiveRecord::Migration
  def change
    add_column :routines, :triggers_count, :integer, null: false, default: 0
  end
end
