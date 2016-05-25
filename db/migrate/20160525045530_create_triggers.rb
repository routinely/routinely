class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.references :routine, null: false, index: true

      t.timestamps null: false
    end
  end
end
