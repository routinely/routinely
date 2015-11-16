class AddConditionsToListeners < ActiveRecord::Migration
  def change
    add_column :listeners, :gt, :float
    add_column :listeners, :lt, :float
  end
end
