class Actuator < Actor
  validates :guid, presence: true, uniqueness: true
end
