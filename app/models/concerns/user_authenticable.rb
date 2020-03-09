# frozen_string_literal: true

module UserAuthenticable
  extend ActiveSupport::Concern

  included do
    attr_accessor :email, :password, :token, :refresh_token
  end

  def authenticate
    auth = AuthService.new(username: email, password: password)
    success = auth.create

    self.response = auth.response

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

    self.response = auth.response

    if success
      self.token = auth.response.dig('data', 'token', 'access_token')
      self.refresh_token = auth.response.dig('data', 'token', 'refresh_token')
    else
      self.token = self.refresh_token = ''
    end
    success
  end

  def token_revoke
    auth = AuthService.new(token: token)
    success = auth.revoke

    self.response = auth.response

    success
  end

  def to_auth_params
    {
        username: email,
        password: password,
        token: token,
        refresh_token: refresh_token
    }
  end
end
