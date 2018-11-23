# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
end

require_relative '../lib/ddsl'

Dir[
  File.expand_path(File.join(File.dirname(__FILE__), 'support/**/*.rb'))
].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
