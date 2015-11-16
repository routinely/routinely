class AddGuidToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :guid, :string, null: false
    add_index :sensors, :guid, unique: true
  end
end
