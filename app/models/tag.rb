class Tag < ActiveRecord::Base
  belongs_to :routine
  belongs_to :user

  validates :routine, presence: true, uniqueness: { scope: :user }
  validates :user, presence: true, uniqueness: { scope: :routine }
end
