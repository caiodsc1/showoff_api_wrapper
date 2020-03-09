module ApplicationHelper
  def prepare_for_collection(object, class_name = nil)
    object_class = class_name || object.class
    objects = object_class.name.downcase.pluralize
    object.response['data'][objects].map{|object| object_class.new(object)}
  end

  def flash_class(type)
    case type
    when 'notice' then 'alert alert-info'
    when 'success' then 'alert alert-success'
    when 'error' then 'alert alert-danger'
    when 'alert' then 'alert alert-error'
    end
  end

  def badge_class(type)
    case type
    when 'visible' then 'badge badge-success'
    when 'hidden' then 'badge badge-danger'
    end
  end
end
