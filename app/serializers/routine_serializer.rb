class RoutineSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :starts_at, :ends_at, :repeats_at

  has_many :sensors
  has_many :actors
  has_many :users

  def repeats_at
    Hash[Routine.values_for_repeats_at.map { |day| [day, object.repeats_at.include?(day)] }]
  end

  class UserSerializer < ActiveModel::Serializer
    attributes :name
  end
end
