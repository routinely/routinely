class AddNoderedConfigToGroups < ActiveRecord::Migration
  def change
    enable_extension "hstore" unless extension_enabled?("hstore")
    add_column :groups, :nodered_config, :hstore
  end
end
