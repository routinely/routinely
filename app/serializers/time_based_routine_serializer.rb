class TimeBasedRoutineSerializer < ActiveModel::Serializer
  attributes :id, :title, :start, :dow, :class_name

  def title
    object.name
  end

  def start
    object.triggers_at.to_s(:time)
  end

  def dow
    object.repeats_at.to_days_of_week
  end

  def class_name
    "fc-time-based-routine"
  end
end
