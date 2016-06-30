module Routines
  class RemoveFlowService
    def initialize(routine)
      @routine = routine
      @client = Nodered.client(routine.group.nodered_host)
    end

    def run!
      if @routine.flow_id
        @client.remove_flow(@routine.flow_id)
        @routine.update(flow_id: nil) if response.ok? # TODO: error handling
      end
    end
  end
end
