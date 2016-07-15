class RemoveGuidFromSensors < ActiveRecord::Migration
  def change
    remove_column :sensors, :guid
  end
end
