class AddNonNullToDurationColumn < ActiveRecord::Migration
  def change
    change_column_null :dependent_routines, :duration, false
  end
end
