class AddConfigToActors < ActiveRecord::Migration
  def change
    enable_extension "hstore" unless extension_enabled?("hstore")
    add_column :actors, :config, :hstore
  end
end
