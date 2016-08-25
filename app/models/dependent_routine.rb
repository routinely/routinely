class DependentRoutine < ActiveRecord::Base
  belongs_to :group

  has_one :inverse_callback, -> { where(target_type: "DependentRoutine") }, foreign_key: :target_id, class_name: "Callback", dependent: :destroy
  has_one :leading_routine, through: :inverse_callback, source: :routine, source_type: :periodic_routine

  has_many :listeners, as: :routine, dependent: :destroy
  has_many :callbacks, as: :routine, dependent: :destroy


  validates :name, presence: true, uniqueness: { scope: :group }
  validates :duration, inclusion: { in: 0..24.hours }
  validates :group, presence: true
end
