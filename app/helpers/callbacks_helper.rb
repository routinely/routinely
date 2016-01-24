module CallbacksHelper
  def link_to_callback_target(callback)
    case callback.target
    when Routine
      link_to(callback.target.name, callback.target)
    else
      callback.target.name
    end
  end
end
