class SensorSerializer < ActiveModel::Serializer
  attributes :id, :name, :icon

  def icon
    view_context.image_path object.icon
  end
end
