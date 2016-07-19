class CreateTimeBasedRoutines < ActiveRecord::Migration
  def change
    create_table :time_based_routines do |t|
      t.string :name, null: false
      t.text :description
      t.time :triggers_at, null: false
      t.integer :repeats_at
      t.boolean :active, null: false, default: true
      t.references :group, index: true, foreign_key: { on_delete: :cascade }, null: false
      t.string :flow_id

      t.timestamps null: false
    end

    add_index :time_based_routines, [:name, :group_id], unique: true
  end
end
