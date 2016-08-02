class TimeBasedRoutine < ActiveRecord::Base
  include Repeatable

  belongs_to :group

  has_many :callbacks, as: :routine, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :group }
  validates :triggers_at, presence: true
  validates :group, presence: true
end
