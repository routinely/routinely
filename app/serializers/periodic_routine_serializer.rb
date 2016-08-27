class PeriodicRoutineSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :start, :end, :dow, :url, :class_name

  def title
    object.name
  end

  def start
    object.starts_at.to_s(:time)
  end

  def end
    object.ends_at.to_s(:time)
  end

  def dow
    object.repeats_at.to_days_of_week
  end

  def url
    url_for object
  end

  def class_name
    "fc-periodic-routine"
  end
end
