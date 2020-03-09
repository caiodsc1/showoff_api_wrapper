class Widget < ApplicationModel
  attr_accessor :id,
                :name,
                :description,
                :kind,
                :new_record,
                :user_token,
                :response

  alias token user_token
  alias errors response

  include UserBelonging

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

  def public_widgets
    success, self.response = WidgetService.public_widgets(self)
    success
  end

  def visible_widgets(search_term = nil)
    success, self.response = WidgetService.visible_widgets(search_term)
    success
  end
end
