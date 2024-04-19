# app/helpers/application_helper.rb

module ApplicationHelper
include Pagy::Frontend
  # This method creates a link with `data-id` `data-fields` attributes. These attributes are used to create new instances of the nested fields through Javascript.
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
        render(association.to_s.singularize + "_fields", f: builder)
      end
      link_to(name,"#",class: "add_fields",data: {id: id,fields: fields.gsub("\n", "")})
  end
end
