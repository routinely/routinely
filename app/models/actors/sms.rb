module Actors
  class Sms < Actor
    store_accessor :config, :receipient
  end
end
