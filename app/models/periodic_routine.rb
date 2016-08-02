class PeriodicRoutine < ActiveRecord::Base
  include Repeatable

  belongs_to :group

  has_many :listeners, as: :routine, dependent: :destroy
  has_many :callbacks, as: :routine, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :group }
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :group, presence: true
end
