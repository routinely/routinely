class AddIconToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :icon, :string
  end
end
