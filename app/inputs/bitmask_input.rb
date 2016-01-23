class BitmaskInput < SimpleForm::Inputs::CollectionCheckBoxesInput
  def input_type
    :check_boxes
  end

  def collection
    klass = object.model_name.name.constantize
    klass.send("values_for_#{attribute_name}")
  end

  def build_nested_boolean_style_item_tag(collection_builder)
    collection_builder.check_box + collection_builder.text.capitalize
  end
end
