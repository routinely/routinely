class User < ActiveRecord::Base
  include Clearance::User

  belongs_to :group

  validates :group, presence: true
end
