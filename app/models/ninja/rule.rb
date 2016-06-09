module Ninja
  class Rule < ActiveRecord::Base
    belongs_to :group

    validates :name, presence: true
    validates :guid, presence: true
    validates :group, presence: true
  end
end
