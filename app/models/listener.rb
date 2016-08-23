class Listener < ActiveRecord::Base
  store_accessor :conditions, :lt, :gt

  belongs_to :routine, polymorphic: true
  belongs_to :sensor

  validates :routine, presence: true
  validates :sensor, presence: true
  validates :gt, absence: true, if: :binary?
  validates :lt, absence: true, if: :binary?
  validate -> {
    unless [gt, lt].any?
      errors.add(:gt, "digital sensors require at least one numeric conditions")
      errors.add(:lt, "digital sensors require at least one numeric conditions")
    end
  }, if: :digital?

  delegate :binary?, :digital?, to: :sensor

  scope :rf, -> { joins(:sensor).merge(Sensor.binary) }
  scope :non_rf, -> { joins(:sensor).merge(Sensor.digital) }

  def to_node(x, y)
    sensor.to_node(conditions, x, y)
  end
end
