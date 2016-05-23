module Api
  class ApplicationController < ApplicationController
    serialization_scope :view_context
  end
end
