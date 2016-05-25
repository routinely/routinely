class AddKindToTriggers < ActiveRecord::Migration
  def change
    add_column :triggers, :kind, :integer, null: false
  end
end
