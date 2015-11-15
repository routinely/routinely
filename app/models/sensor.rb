class Sensor < ActiveRecord::Base
  validates :name, presence: true
end
