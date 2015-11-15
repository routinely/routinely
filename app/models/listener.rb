class Listener < ActiveRecord::Base
  belongs_to :routine
  belongs_to :sensor

  validates :routine, presence: true, uniqueness: { scope: :sensor }
  validates :sensor, presence: true, uniqueness: { scope: :routine }
end
