class CreateNinjaRules < ActiveRecord::Migration
  def change
    create_table :ninja_rules do |t|
      t.string :guid, null: false
      t.string :name, null: false
      t.references :group, null: false

      t.timestamps null: false
    end
    add_foreign_key :ninja_rules, :groups, on_delete: :cascade
  end
end
