class DependentRoutine < ActiveRecord::Base
  include Flowable

  has_paper_trail

  belongs_to :group

  has_one :inverse_callback, -> { where(target_type: "DependentRoutine") }, foreign_key: :target_id, inverse_of: :target, class_name: "Callback", dependent: :destroy, required: true
  has_one :leading_routine, through: :inverse_callback, source: :routine, source_type: "PeriodicRoutine"

  has_one :rf_listener, -> { rf }, as: :routine, class_name: "Listener"
  has_one :rf_sensor, through: :rf_listener, source: :sensor

  has_many :listeners, -> { non_rf }, as: :routine, dependent: :destroy
  has_many :sensors, through: :listeners, source: :sensor

  has_many :callbacks, as: :routine, dependent: :destroy
  has_many :actors, through: :callbacks, source: :target, source_type: "Actor"

  has_many :events, as: :routine, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :group }
  validates :duration, inclusion: { in: 0..24.hours }
  validates :group, presence: true
  validates :sensors, length: { maximum: 2 }

  accepts_nested_attributes_for :inverse_callback

  delegate :mqtt_broker, to: :group
  delegate :delay, to: :inverse_callback

  def mqtt_topic_for(event_type)
    leading_routine.mqtt_topic_for(event_type)
  end

  def valid_flow?
    (rf_listener.present? || listeners.any?) && callbacks.any?
  end
end
