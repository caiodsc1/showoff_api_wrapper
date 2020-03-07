# frozen_string_literal: true

class AuthService
  attr_accessor :grant_type,
                :username,
                :password,
                :token,
                :refresh_token,
                :response

  alias errors response

  def initialize(*args)
    args.first&.each do |attr, value|
      try("#{attr}=", value)
    end
  end

  def create
    self.grant_type = 'password'

    call(params: as_json(only: %w[grant_type username password]),
         url: '/oauth/token')
  end

  def revoke
    call(params: as_json(only: %w[token]),
         url: '/oauth/revoke',
         headers: { authorization: "Bearer #{token}" },
         oauth: false)
  end

  def refresh
    self.grant_type = 'refresh_token'

    call(params: as_json(only: %w[grant_type refresh_token]),
         url: '/oauth/token',
         headers: { authorization: "Bearer #{token}" })
  end

  def call(params: {}, url: '', headers: {}, oauth: true)
    params.merge! oauth_hash if oauth

    response = RestClient::Request.execute(method: :post,
                                           url: ENV['APP_BASE_URL'] + url,
                                           payload: params.to_json,
                                           headers: headers.merge!({ content_type: 'application/json' }))
    self.response = JSON.parse(response.body)

    true
  rescue RestClient::ExceptionWithResponse => e
    self.response = JSON.parse(e.response&.body)

    false
  end

  private

  def oauth_hash
    {
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET']
    }
  end
end
