class PeriodicRoutineSerializer < ActiveModel::Serializer
  attributes :id, :title, :start, :end, :dow

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
end
