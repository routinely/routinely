class CreateRoutines < ActiveRecord::Migration
  def change
    create_table :routines do |t|
      t.string :name, null: false
      t.text :description
      t.time :starts_at
      t.time :ends_at
      t.integer :duration
      t.integer :repeats_at
      t.boolean :active, null: false, default: true
      t.boolean :once, null: false, default: false

      t.timestamps null: false
    end
  end
end
