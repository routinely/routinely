class DropRoutines < ActiveRecord::Migration
  def change
    drop_table :routines
  end
end
