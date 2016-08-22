module Flowable
  extend ActiveSupport::Concern

  def to_flow
    return {} if callbacks.empty?

    serializer = "Nodered::#{self.class.name}Serializer".constantize
    serializer.new(self).as_json
  end
end
