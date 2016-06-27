class AddAllDayToRoutines < ActiveRecord::Migration
  def change
    add_column :routines, :all_day, :boolean, null: false, default: false
  end
end
