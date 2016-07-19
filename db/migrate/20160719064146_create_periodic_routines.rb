class CreatePeriodicRoutines < ActiveRecord::Migration
  def change
    create_table :periodic_routines do |t|
      t.string :name, null: false
      t.text :description
      t.time :starts_at, null: false
      t.time :ends_at, null: false
      t.integer :repeats_at
      t.boolean :active, null: false, default: true
      t.boolean :once, null: false, default: false
      t.references :group, index: true, foreign_key: { on_delete: :cascade }, null: false
      t.string :flow_id

      t.timestamps null: false
    end

    add_index :periodic_routines, [:name, :group_id], unique: true
  end
end
