class AddTypeToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :type, :string, null: false, index: true
  end
end
