class CreateCallbacks < ActiveRecord::Migration
  def change
    create_table :callbacks do |t|
      t.string :type, null: false, index: true
      t.references :routine, null: false, index: true
      t.references :target, polymorphic: true, null: false, index: true
      t.integer :delay
      t.boolean :once, null: false, default: false

      t.timestamps null: false
    end
    add_foreign_key :callbacks, :routines, on_delete: :cascade
    add_index :callbacks, [:type, :routine_id, :target_type, :target_id], unique: true, name: :index_callbacks_on_type_and_routine_id_and_target
  end
end
