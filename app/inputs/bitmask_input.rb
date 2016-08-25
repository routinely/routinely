class BitmaskInput < SimpleForm::Inputs::CollectionCheckBoxesInput
  def input_type
    :check_boxes
  end

  def input_options
    options = super
    options[:checked] = object.send(attribute_name)
    options
  end

  def collection
    @collection ||= begin
      klass = object.model_name.name.constantize
      klass.send("values_for_#{attribute_name}")
    end
  end
end
