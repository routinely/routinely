class Actor < ActiveRecord::Base
  has_many :callbacks, as: :target, dependent: :destroy
  has_many :routines, through: :callbacks

  validates :name, presence: true
end
