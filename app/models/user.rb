class User < ActiveRecord::Base
  include Clearance::User

  belongs_to :group

  validates :group, presence: true
  validates :timezone, presence: true, inclusion: { in: ActiveSupport::TimeZone.zones_map(&:name).keys }
end
