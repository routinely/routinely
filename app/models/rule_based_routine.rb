class RuleBasedRoutine < ActiveRecord::Base
  include Repeatable
  include Flowable
  include Policeable
  include HasEvents

  audited except: :flow_id
  has_associated_audits

  has_paper_trail meta: { triggers_count: :triggers_count }, ignore: [:flow_id]

  belongs_to :group

  has_one :rf_listener, -> { rf }, as: :routine, class_name: "Listener"
  has_one :rf_sensor, through: :rf_listener, source: :sensor

  has_many :listeners, -> { non_rf }, as: :routine, dependent: :destroy
  has_many :sensors, through: :listeners, source: :sensor

  has_many :callbacks, as: :routine, dependent: :destroy
  has_many :actors, through: :callbacks, source: :target, source_type: "Actor"

  validates :name, presence: true, uniqueness: { scope: :group }
  validates :group, presence: true
  validates :sensors, length: { maximum: 2 }

  def valid_flow?
    (rf_listener.present? || listeners.any?) && callbacks.any?
  end
end
