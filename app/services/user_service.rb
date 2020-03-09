# frozen_string_literal: true

class UserService
  @@create_attributes = %w[email password first_name last_name image_url].freeze
  @@update_attributes = %w[first_name last_name image_url date_of_birth].freeze

  def self.create_user(user)
    ApiService.call(method: :post, url: '/users',
                    params: { user: user.as_json(only: @@create_attributes) })
  end

  def self.update_user(user)
    ApiService.call(method: :put, url: '/users/me',
                    params: { user: user.as_json(only: @@update_attributes) },
                    headers: { authorization: "Bearer #{user.token}" })
  end

  def self.check_email(user)
    ApiService.call(method: :get, url: '/users/email',
                    params: { email: user.email })
  end

  def self.reset_password(user)
    ApiService.call(method: :post, url: '/users/reset_password',
                    params: { user: { email: user.email } })
  end

  def self.change_password(user)
    ApiService.call(method: :post, url: '/users/me/password',
                    params: { user:
                                  { current_password: user.current_password,
                                    new_password: user.new_password } },
                    headers: { authorization: "Bearer #{user.token}" })
  end

  def self.show_authenticated_user(user)
    ApiService.call(method: :get, url: '/users/me', headers: { authorization: "Bearer #{user.token}" })
  end

  def self.show_user_by_id(user)
    ApiService.call(method: :get, url: "/users/#{user.id}", headers: { authorization: "Bearer #{user.token}" })
  end

  def self.private_widgets(user, search_term)
    ApiService.call(method: :get, url: '/users/me/widgets',
                    params: { term: search_term }.compact,
                    headers: { authorization: "Bearer #{user.token}" })
  end
end
