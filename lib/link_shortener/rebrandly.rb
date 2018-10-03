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
    rescue StandardError => e
      raise(e) if ENV['DEBUG_LINKS'].present?
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
  end
end
