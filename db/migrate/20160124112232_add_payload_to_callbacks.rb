class AddPayloadToCallbacks < ActiveRecord::Migration
  def change
    add_column :callbacks, :payload, :json
  end
end
