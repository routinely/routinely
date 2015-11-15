class Sensor < ActiveRecord::Base
  has_many :listeners, dependent: :destroy
  has_many :routines, through: :listeners

  validates :name, presence: true
end
