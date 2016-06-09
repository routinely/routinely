class ListenerSerializer < ActiveModel::Serializer
  attributes :id, :name, :kind, :gt, :lt, :icon

  def name
    object.sensor.name
  end

  def kind
    object.sensor.kind
  end

  def icon
    view_context.image_path(object.sensor.icon)
  end
end
