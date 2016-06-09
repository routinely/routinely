class RoutineSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :starts_at, :ends_at, :repeats_at, :active

  has_many :listeners
  has_many :callbacks
  has_many :users

  def repeats_at
    object.repeats_at.to_s
  end

  class UserSerializer < ActiveModel::Serializer
    attributes :name
  end
end
