class EventSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :start, :end, :dow, :url, :class_name

  def title
    routine.name
  end

  def start
    object.created_at.to_s(:time)
  end

  def end
    (object.created_at + routine.duration).to_s(:time)
  end

  def dow
    [object.created_at.wday]
  end

  def url
    url_for routine
  end

  def class_name
    "fc-dependent-routine"
  end

  private

  def routine
    @routine ||= object.routine
  end
end
