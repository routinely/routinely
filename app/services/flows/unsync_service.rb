module Flows
  class UnsyncService
    def initialize(group)
      @group = group
    end

    def run!
      return unless @group.synced?

      [PeriodicRoutine, DependentRoutine, TimeBasedRoutine, RuleBasedRoutine].each do |klass|
        klass.where(group: @group).find_each do |routine|
          client.remove_flow(routine.flow_id) if routine.flow_id.present?
          routine.update(flow_id: nil)
        end
      end

      @group.update(synced: false)
    end

    private

    def client
      @client ||= Nodered::Client.new(@group.nodered_host)
    end
  end
end
