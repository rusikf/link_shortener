require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'addressable'
require 'rest_client'

module LinkShortener
  class Main
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
      %w[http https].include?(parsed.scheme) && parsed.domain.present?
    rescue
      nil
    end

    def check_env!
      raise 'Rebrandly api key not defined in .env' if ENV['REBRANDLY_API_KEY'].blank?
    end
  end
end
