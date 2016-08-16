class ChangeConditionsOnListenersToJson < ActiveRecord::Migration
  def change
    remove_column :listeners, :gt, :float
    remove_column :listeners, :lt, :float
    add_column :listeners, :conditions, :json
  end
end
