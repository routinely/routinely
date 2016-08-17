class RoutineForm
  extend ActiveModel::Naming
  include ActiveModel::Model

  attr_reader :routine

  delegate :name, :description, :starts_at, :ends_at, :repeats_at, to: :routine

  validates :name, presence: true
  validates :ends_at, numericality: { greater_than: :starts_at }, allow_nil: true, if: :starts_at?

  class << self
    def model_name
      ActiveModel::Name.new(self, nil, Routine.name)
    end
  end

  def initialize(routine)
    @routine = routine
  end
end
