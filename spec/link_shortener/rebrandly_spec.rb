require 'spec_helper'

describe LinkShortener::Rebrandly do
  let(:service) { described_class }
  let(:url) { 'https://google.com' }
  let(:short_url) { 'go.com' }

  specify 'call service' do
    ClimateControl.modify REBRANDLY_API_KEY: 'aa' do
      body = { 'shortUrl' => short_url }.to_json

      stub_request(:get, "https://api.rebrandly.com/v1/domains").
        to_return(status: 200, body: "", headers: {})

      stub_request(:post, "https://api.rebrandly.com/v1/links").
        to_return(status: 200, body: body)

      expect(service.new(url).call).to eq('http://go.com')
    end
  end
end