require 'spec_helper'

describe LinkShortener::Main do
  let(:main) { described_class }
  let(:rebrandly) { LinkShortener::Rebrandly }
  let(:url) { 'https://google.com' }

  specify 'call service' do
    allow_any_instance_of(rebrandly).to receive(:call)
    expect_any_instance_of(rebrandly).to receive(:call).once

    ClimateControl.modify REBRANDLY_API_KEY: 'aa' do
      main.new(url).call
    end
  end

  specify 'dont call service' do
    expect_any_instance_of(rebrandly).not_to receive(:call)
    main.new(nil).call
  end
end