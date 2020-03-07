module UserWidgetOwner
  extend ActiveSupport::Concern

  def get_private_widgets(search_term = nil)
    success, self.response = UserWidgetService.get_private_widgets(self, search_term)
    success
  end

  def get_widgets_by_user_id(search_term = nil)
    success, self.response = UserWidgetService.get_widgets_by_user_id(self, search_term)
    success
  end
end
