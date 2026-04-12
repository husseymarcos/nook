ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"
require "mocha/minitest"
require_relative "test_helpers/session_test_helper"

WebMock.disable_net_connect!(allow_localhost: true)

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
    include SessionTestHelper
  end
end

class ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }
  teardown { Current.clear_all }
end
