class AddTimezoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :timezone, :string, default: "Seoul"
  end
end
