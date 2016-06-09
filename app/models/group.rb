class Group < ActiveRecord::Base
  has_many :rules, class_name: "Ninja::Rule", dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :routines, dependent: :destroy
  has_many :sensors, dependent: :destroy
  has_many :actors, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
