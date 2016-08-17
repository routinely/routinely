module Nodered
  class FlowSerializer < ActiveModel::Serializer
    attributes :label, :nodes

    def label
      object.name
    end
  end
end
