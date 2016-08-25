class TimeBasedRoutine < ActiveRecord::Base
  include Repeatable
  include Flowable

  belongs_to :group

  has_many :callbacks, as: :routine, dependent: :destroy
  has_many :actors, through: :callbacks, source: :target, source_type: "Actor"

  has_many :events, as: :routine, dependent: :destroy

  accepts_nested_attributes_for :callbacks

  validates :name, presence: true, uniqueness: { scope: :group }
  validates :triggers_at, presence: true
  validates :group, presence: true

  def crontab
    "#{triggers_at.min} #{triggers_at.hour} * * #{repeats_at.to_days_of_week.join(',')}"
  end

  def valid_flow?
    callbacks.any?
  end
end
