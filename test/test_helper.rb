ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails/capybara'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def setup
    #yml fixtures created with db_fixtures_dump gem
    #  FIXTURES_PATH=test/fixtures rake db:fixtures:dump
    #load "#{Rails.root}/db/seeds.rb"
  end

end
