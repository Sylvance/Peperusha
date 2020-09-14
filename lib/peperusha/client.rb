require 'faraday'
require 'json'

require_relative('./logs.rb')

module Peperusha
  class Client
    def self.invoke_token_request(consumer_key, consumer_secret)
      conn = Faraday.new(url: 'https://sandbox.safaricom.co.ke') do |build|
        build.request :url_encoded
        build.use Peperusha::Logs
        build.adapter  Faraday.default_adapter
      end

      conn.basic_auth(consumer_key, consumer_secret)

      conn.get('oauth/v1/generate') do |req|
        req.params['grant_type'] = 'client_credentials'
      end
    end

    def self.invoke_post_request(token, domain_url, body)
      base_url = 'https://sandbox.safaricom.co.ke'
      headers = {
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{token}",
        'Content-Type' => 'application/json'
      }

      conn = Faraday.new(url: base_url, headers: headers) do |build|
        build.request :url_encoded
        build.use Peperusha::Logs
        build.adapter  Faraday.default_adapter
      end

      conn.post(domain_url) do |req|
        req.body = body.to_json
      end
    end

    def self.build_errors_collection(response)
      data = JSON.parse(response.body)
      [
        {
          status_code: response.status,
          error: {
            code: data['errorCode'],
            errorMessage: data['errorMessage']
          }
        }
      ]
    end
  end
end
