module Routines
  class BuildFlowService
    def initialize(routine)
      @routine = routine
    end

    def run!
      {
        label: @routine.name,
        nodes: [
          {
            id: SecureRandom.uuid,
            type: "subflow:#{@routine.group.rx_subflow}",
            x: 100,
            y: 100,
            wires: [
              []
            ]
          },
        ]
      }
    end
  end
end
