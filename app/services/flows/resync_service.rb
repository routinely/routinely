module Flows
  class ResyncService
    def initialize(group)
      @group = group
    end

    def run!
      return if @group.synced?

      [PeriodicRoutine, DependentRoutine, TimeBasedRoutine, RuleBasedRoutine].each do |klass|
        klass.where(group: @group).find_each do |routine|
          unless routine.to_flow.empty?
            response = client.add_flow(routine.to_flow)
            routine.update(flow_id: response["id"])
          end
        end
      end

      @group.update(synced: true)
    end

    private

    def client
      @client ||= Nodered::Client.new(@group.nodered_host)
    end
  end
end
