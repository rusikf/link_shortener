module LinkShortener
  class Rebrandly
    API_URL = 'https://api.rebrandly.com/v1/'.freeze

    def initialize(url)
      @url = url
    end

    def call
      domain_id = fetch_domain_id

      body = { destination: @url }
      body[:domain] = { id: domain_id } if domain_id

      response = RestClient.post endpoint(:links), body.to_json, headers
      protocol = protocol_for(response)
      url = parse_field(response, 'shortUrl')
      return nil if url.blank?
      "#{protocol}://#{url}"
    rescue RestClient::ExceptionWithResponse => e
      process_api_error(e)
    rescue => e
      Rollbar.warning(e)
      nil
    end

    private

    def headers
      @headers ||= { content_type: :json, accept: :json, apikey: ENV['REBRANDLY_API_KEY'] }
    end

    def endpoint(title)
      URI.join(API_URL, title.to_s).to_s
    end

    def fetch_domain_id
      response1 = RestClient.get endpoint(:domains), headers
      JSON.parse(response1.body).sample.try(:[], 'id')
    rescue
      nil
    end

    def parse_field(response, title)
      JSON.parse(response.body).try(:[], title) rescue nil
    end

    def protocol_for(response)
      parse_field(response, 'https') ? 'https' : 'http'
    end

    def process_api_error(e)
      key = "link_error_raised_#{e.message[0..10]}"

      return if redis.get(key) # prevent reaching rollbar limits
      redis.set(key, true)
      redis.expire(key, 2.hours.to_i)
      Rollbar.error("#{e.message}; #{e.response.body}")
      nil
    end

    def redis
      Redis.current
    end
  end
end
