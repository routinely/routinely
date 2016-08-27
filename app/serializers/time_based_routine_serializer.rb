class TimeBasedRoutineSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :start, :dow, :url, :class_name

  def title
    object.name
  end

  def start
    object.triggers_at.to_s(:time)
  end

  def dow
    object.repeats_at.to_days_of_week
  end

  def url
    url_for object
  end

  def class_name
    "fc-time-based-routine"
  end
end
