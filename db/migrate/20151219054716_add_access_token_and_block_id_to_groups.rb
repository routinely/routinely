class AddAccessTokenAndBlockIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :access_token, :string
    add_column :groups, :block_id, :string
  end
end
