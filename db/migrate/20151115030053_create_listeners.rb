class CreateListeners < ActiveRecord::Migration
  def change
    create_table :listeners do |t|
      t.references :routine, null: false, index: true
      t.references :sensor, null: false, index: true

      t.timestamps null: false
    end
    add_foreign_key :listeners, :routines, on_delete: :cascade
    add_foreign_key :listeners, :sensors, on_delete: :cascade
    add_index :listeners, [:routine_id, :sensor_id], unique: true
  end
end
