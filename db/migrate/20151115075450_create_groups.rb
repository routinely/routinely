class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
    add_reference :users, :group, null: false, index: true
    add_reference :routines, :group, null: false, index: true
    add_reference :sensors, :group, null: false, index: true
    add_reference :actors, :group, null: false, index: true
    add_index :routines, [:name, :group_id], unique: true
    add_index :sensors, [:name, :group_id], unique: true
    add_index :actors, [:name, :group_id], unique: true
    add_foreign_key :users, :groups, on_delete: :cascade
    add_foreign_key :routines, :groups, on_delete: :cascade
    add_foreign_key :sensors, :groups, on_delete: :cascade
    add_foreign_key :actors, :groups, on_delete: :cascade
  end
end
