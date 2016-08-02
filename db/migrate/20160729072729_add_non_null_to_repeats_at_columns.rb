class AddNonNullToRepeatsAtColumns < ActiveRecord::Migration
  def change
    change_column_null :time_based_routines, :repeats_at, false
    change_column_null :rule_based_routines, :repeats_at, false
    change_column_null :periodic_routines, :repeats_at, false
  end
end
