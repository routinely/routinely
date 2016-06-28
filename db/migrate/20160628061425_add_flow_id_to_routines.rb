class AddFlowIdToRoutines < ActiveRecord::Migration
  def change
    add_column :routines, :flow_id, :string
  end
end
