class AddNoderedHostToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :nodered_host, :string
    remove_column :groups, :access_token
    remove_column :groups, :block_id
  end
end
