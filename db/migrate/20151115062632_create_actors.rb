class CreateActors < ActiveRecord::Migration
  def change
    create_table :actors do |t|
      t.string :type, null: false, index: true
      t.string :name, null: false
      t.text :description

      t.timestamps null: false
    end
  end
end
