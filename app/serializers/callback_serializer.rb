class CallbackSerializer < ActiveModel::Serializer
  attributes :id, :condition, :type, :name, :icon, :delay, :once, :payload

  def condition
    object.type
  end

  def type
    object.target_type
  end

  def name
    object.target.name
  end

  def icon
    case object.target
    when Actor
      view_context.image_path(object.target.icon)
    end
  end
end
