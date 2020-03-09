module UserWidgetOwner
  extend ActiveSupport::Concern

  def private_widgets(search_term = nil)
    success, self.response = UserWidgetService.private_widgets(self, search_term)
    success
  end

  def widgets_by_user_id(search_term = nil)
    success, self.response = UserWidgetService.widgets_by_user_id(self, search_term)
    success
  end
end
