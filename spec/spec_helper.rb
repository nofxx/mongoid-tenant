# require 'codeclimate-test-reporter'
# CodeClimate::TestReporter.start
if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

$LOAD_PATH << File.expand_path('../../lib', __FILE__)

# require 'pry'
# require 'database_cleaner'
require 'mongoid'
require 'mongoid-rspec'

require 'mongoid/tenant'

ENV['MONGOID_ENV'] = 'test'

db_config = {
  default: {
    database: 'mongoid_tenant_test',
    hosts: ["localhost: #{ENV['MONGODB_PORT'] || 27_017}"],
    options: {}
  }
}

Mongoid.configure do |config|
  config.load_configuration(
    if Mongoid::VERSION >= '5'
      { clients: db_config }
    else
      { sessions: db_config }
    end
  )
end

require 'support/models'

Mongo::Logger.logger.level = Logger::INFO if Mongoid::VERSION >= '5'

RSpec.configure do |config|
  config.include Mongoid::Matchers

  config.before(:each) do
    Mongoid.purge!
  end

  config.after(:suite) do
    puts "\n# With Mongoid v#{Mongoid::VERSION}"
  end
end
