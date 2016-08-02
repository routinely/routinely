class TimeBasedRoutine < ActiveRecord::Base
  include Repeatable

  belongs_to :group

  has_many :callbacks, as: :routine, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :group }
  validates :triggers_at, presence: true
  validates :group, presence: true

  def crontab
    days = []
    days << 0 if repeats_at? :sun
    days << 1 if repeats_at? :mon
    days << 2 if repeats_at? :tue
    days << 3 if repeats_at? :wed
    days << 4 if repeats_at? :thu
    days << 5 if repeats_at? :fri
    days << 6 if repeats_at? :sat

    "#{triggers_at.min} #{triggers_at.hour} * * #{days.join(',')}"
  end
end
