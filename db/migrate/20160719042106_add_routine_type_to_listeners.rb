class AddRoutineTypeToListeners < ActiveRecord::Migration
  def change
    remove_index :listeners, column: [:routine_id, :sensor_id]
    remove_column :listeners, :routine_id
    add_reference :listeners, :routine, polymorphic: true, null: false, index: true
  end
end
