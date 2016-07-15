class RemoveGuidFromActors < ActiveRecord::Migration
  def change
    remove_column :actors, :guid
  end
end
