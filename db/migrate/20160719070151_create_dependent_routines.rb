class CreateDependentRoutines < ActiveRecord::Migration
  def change
    create_table :dependent_routines do |t|
      t.string :name, null: false
      t.text :description
      t.integer :duration
      t.boolean :active, null: false, default: true
      t.boolean :once, null: false, default: false
      t.references :group, index: true, foreign_key: { on_delete: :cascade }, null: false
      t.string :flow_id

      t.timestamps null: false
    end

    add_index :dependent_routines, [:name, :group_id], unique: true
  end
end
