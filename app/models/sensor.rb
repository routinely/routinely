class Sensor < ActiveRecord::Base
  belongs_to :group

  has_many :listeners, dependent: :destroy
  has_many :routines, through: :listeners

  validates :name, presence: true, uniqueness: { scope: :group }
  validates :group, presence: true
end
