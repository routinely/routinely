class AddRoutineTypeToCallbacks < ActiveRecord::Migration
  def change
    remove_index :callbacks, name: :index_callbacks_on_type_and_routine_id_and_target
    remove_column :callbacks, :routine_id
    add_reference :callbacks, :routine, polymorphic: true, null: false, index: true
  end
end
