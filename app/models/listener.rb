class Listener < ActiveRecord::Base
  belongs_to :routine
  belongs_to :sensor

  validates :routine, presence: true, uniqueness: { scope: :sensor }
  validates :sensor, presence: true, uniqueness: { scope: :routine }
  validates :gt, absence: true, unless: -> { sensor.digital? }
  validates :lt, absence: true, unless: -> { sensor.digital? }

  delegate :binary?, :digital?, to: :sensor
end
