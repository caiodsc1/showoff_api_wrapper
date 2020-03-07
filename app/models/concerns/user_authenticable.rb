# frozen_string_literal: true

module UserAuthenticable
  extend ActiveSupport::Concern

  included do
    attr_accessor :password, :token, :refresh_token
    # current -> :email, :first_name, :last_name, :password, :current_password, :new_password, :date_of_birth, :image_url, :new_record, :token, :response

    alias username email
  end

  def authenticate
    auth = AuthService.new(username: username, password: password)
    success = auth.create
    if success
      self.token = auth.response.dig('data', 'token', 'access_token')
      self.refresh_token = auth.response.dig('data', 'token', 'refresh_token')
    else
      self.token = self.refresh_token = ''
    end
    success
  end

  def token_refresh
    auth = AuthService.new(token: token, refresh_token: refresh_token)
    success = auth.refresh
    if success
      self.token = auth.response.dig('data', 'token', 'access_token')
      self.refresh_token = auth.response.dig('data', 'token', 'refresh_token')
    else
      self.token = self.refresh_token = ''
    end
    success
  end

  def token_revoke
    success, self.response = AuthService.new(token: token).revoke
    success
  end
end
