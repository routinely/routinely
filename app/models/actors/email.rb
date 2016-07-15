module Actors
  class Email < Actor
    store_accessor :config, :receipient
  end
end
