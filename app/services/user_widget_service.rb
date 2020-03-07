# frozen_string_literal: true

class UserWidgetService
  def self.get_private_widgets(user, search_term = nil)
    ApiService.call(method: :get, url: '/users/me/widgets',
                    params: { term: search_term }.compact,
                    headers: { authorization: "Bearer #{user.token}" })
  end

  def self.get_widgets_by_user_id(user, search_term = nil)
    ApiService.call(method: :get, url: "/users/#{user.id}/widgets",
                    params: { term: search_term }.compact,
                    headers: { authorization: "Bearer #{user.token}" })
  end
end
