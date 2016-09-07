class PeriodicRoutine < ActiveRecord::Base
  include Repeatable
  include Flowable
  include Policeable
  include HasEvents

  has_paper_trail meta: { starts_count: :starts_count, triggers_count: :triggers_count }, ignore: [:flow_id]

  belongs_to :group

  has_one :rf_listener, -> { rf }, as: :routine, class_name: "Listener"
  has_one :rf_sensor, through: :rf_listener, source: :sensor

  has_many :listeners, -> { non_rf }, as: :routine, dependent: :destroy
  has_many :sensors, through: :listeners, source: :sensor

  has_many :callbacks, as: :routine, dependent: :destroy
  has_many :actors, through: :callbacks, source: :target, source_type: "Actor"
  has_many :dependent_routines, through: :callbacks, source: :target, source_type: "DependentRoutine" do
    def on_triggers; merge(::Callback.on_triggers); end
    def on_exits; merge(::Callback.on_exits); end
  end

  validates :name, presence: true, uniqueness: { scope: :group }
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :group, presence: true
  validates :sensors, length: { maximum: 2 }

  delegate :mqtt_broker, to: :group

  before_destroy :destroy_dependents, prepend: true

  def mqtt_topic_for(event_type)
    "#{model_name.name}/#{id}/#{event_type}"
  end

  def valid_flow?
    (rf_listener.present? || listeners.any?) && (callbacks.any? || dependent_routines.any?)
  end

  private

  def destroy_dependents
    dependent_routines.map(&:destroy)
  end
end
