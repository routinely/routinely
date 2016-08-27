class RuleBasedRoutineSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :allDay, :dow, :url, :class_name

  def title
    object.name
  end

  def allDay
    true
  end

  def dow
    object.repeats_at.to_days_of_week
  end

  def url
    url_for object
  end

  def class_name
    "fc-rule-based-routine"
  end
end
