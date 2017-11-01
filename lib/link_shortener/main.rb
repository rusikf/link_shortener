module LinkShortener
  class Main
    API_URL = 'https://api.rebrandly.com/v1/'.freeze

    def initialize(url)
      @url = url.to_s
    end

    def call
      return nil if @url.blank? || !valid_url?
      check_env!

      LinkShortener::Rebrandly.new(@url).call
    end

    private

    def valid_url?
      parsed = Addressable::URI.parse(@url)
      %w[http https].include?(parsed.scheme)
    rescue
      nil
    end

    def check_env!
      raise 'Rebrandly api key not defined in .env' if ENV['REBRANDLY_API_KEY'].blank?
    end
  end
end
