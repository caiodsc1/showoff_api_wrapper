class Widget
  attr_accessor :id,
                :name,
                :description,
                :kind,
                :new_record,
                :user_token,
                :response

  alias token user_token
  alias errors response

  def initialize(*args)
    args.first&.each do |attr, value|
      try("#{attr}=", value)
    end
  end

  def save
    success, self.response = if new_record
                               WidgetService.create_widget(self)
                             else
                               WidgetService.update_widget(self)
                             end
    self.id = response.dig('data', 'widget', 'id') if success && new_record
    success
  end

  def delete_widget
    success, self.response = WidgetService.delete_widget(self)
    success
  end

  def get_public_widgets
    success, self.response = WidgetService.get_public_widgets(self)
    success
  end

  def get_visible_widgets(search_term = nil)
    success, self.response = WidgetService.get_visible_widgets(search_term)
    success
  end
end
