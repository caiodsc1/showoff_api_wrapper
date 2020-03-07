# frozen_string_literal: true

class ApiService
  def self.call(params: {}, url: '', method: :get, headers: {}, oauth: true)
    params.merge! oauth_hash if oauth

    response = RestClient::Request.execute(method: method,
                                           url: ENV['API_BASE_URL'] + url,
                                           payload: params.to_json,
                                           headers: headers.merge!({content_type: 'application/json'}))
    [true, JSON.parse(response.body)]
  rescue RestClient::ExceptionWithResponse => e
    [false, JSON.parse(e.response&.body)]
  end

  private

  def self.oauth_hash
    {
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV['CLIENT_SECRET']
    }
  end
end
