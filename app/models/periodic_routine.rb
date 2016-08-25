class PeriodicRoutine < ActiveRecord::Base
  include Repeatable
  include Flowable

  belongs_to :group

  has_one :rf_listener, -> { rf }, as: :routine, class_name: "Listener"
  has_one :rf_sensor, through: :rf_listener, source: :sensor

  has_many :listeners, -> { non_rf }, as: :routine, dependent: :destroy
  has_many :sensors, through: :listeners, source: :sensor

  has_many :callbacks, as: :routine, dependent: :destroy
  has_many :actors, through: :callbacks, source: :target, source_type: "Actor"
  has_many :dependent_routines, through: :callbacks, source: :target, source_type: "DependentRoutine", dependent: :destroy do
    def on_triggers; merge(::Callback.on_triggers); end
    def on_exits; merge(::Callback.on_exits); end
  end

  has_many :events, as: :routine, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :group }
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :group, presence: true
  validates :sensors, length: { maximum: 2 }

  delegate :mqtt_broker, to: :group

  def mqtt_topic_for(event_type)
    "#{model_name.name}/#{id}/#{event_type}"
  end

  def valid_flow?
    (rf_listener.present? || listeners.any?) && (callbacks.any? || dependent_routines.any?)
  end
end
