module HasEvents
  extend ActiveSupport::Concern

  included do
    has_many :events, as: :routine, dependent: :destroy
  end

  def starts_count
    events.started.count
  end

  def triggers_count
    events.triggered.count
  end
end
