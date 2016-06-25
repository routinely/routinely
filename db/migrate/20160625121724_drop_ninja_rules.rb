class DropNinjaRules < ActiveRecord::Migration
  def change
    drop_table :ninja_rules
  end
end
