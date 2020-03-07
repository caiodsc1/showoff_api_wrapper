require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = 'spec/support/vcr_cassettes'
  config.allow_http_connections_when_no_cassette = true
  config.configure_rspec_metadata!
  config.hook_into :webmock
  config.before_record do |spec|
    spec.response.body.force_encoding('UTF-8')
  end
end
