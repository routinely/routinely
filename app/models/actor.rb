class Actor < ActiveRecord::Base
  belongs_to :group

  has_many :callbacks, as: :target, dependent: :destroy
  has_many :routines, through: :callbacks

  validates :name, presence: true, uniqueness: { scope: :group }
  validates :group, presence: true

  scope :callable, -> { all }
end
