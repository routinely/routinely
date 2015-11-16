class AddGuidToActors < ActiveRecord::Migration
  def change
    add_column :actors, :guid, :string
    add_index :actors, :guid, unique: true
  end
end
