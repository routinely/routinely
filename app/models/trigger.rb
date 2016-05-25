class Trigger < ActiveRecord::Base
  belongs_to :routine, counter_cache: true

  validates :routine, presence: true
end
