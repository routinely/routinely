class AddKindToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :kind, :integer, null: false
  end
end
