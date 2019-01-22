require 'bundler/setup'
require 'delivery/client/delivery_client'
require 'delivery/query_parameters/filters'
require 'delivery/client/url_provider'
require 'delivery/resolvers/content_link_resolver'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
