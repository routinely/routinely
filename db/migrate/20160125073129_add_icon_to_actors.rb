class AddIconToActors < ActiveRecord::Migration
  def change
    add_column :actors, :icon, :string
  end
end
