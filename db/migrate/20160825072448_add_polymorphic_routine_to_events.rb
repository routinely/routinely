class AddPolymorphicRoutineToEvents < ActiveRecord::Migration
  def change
    remove_reference :events, :routine, index: true
    add_reference :events, :routine, polymorphic: true, null: false, index: true
  end
end
