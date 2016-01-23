class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :routine, null: false, index: true
      t.references :user, null: false, index: true

      t.timestamps null: false
    end
    add_foreign_key :tags, :routines, on_delete: :cascade
    add_foreign_key :tags, :users, on_delete: :cascade
    add_index :tags, [:routine_id, :user_id], unique: true
  end
end
