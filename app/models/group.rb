class Group < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :routines, dependent: :destroy
  has_many :sensors, dependent: :destroy
  has_many :actuators, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end