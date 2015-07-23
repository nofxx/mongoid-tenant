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

DB_CONFIG = {
  default: {
    database: 'mongoid_tenant_test',
    hosts: ["localhost: #{ENV['MONGODB_PORT'] || 27_017}"],
    options: {}
  }
}

def new_conn(db = '')
  Mongo::Client.new(DB_CONFIG[:default][:hosts], database: db)
end

def fetch_dbs
  new_conn.database_names.to_a # each { |n| START_DBS << n }
end

def drop_shared
  %w( a_casseta_test a_planeta_test b_casseta_test b_planeta_test ).each do |db|
    new_conn(db).database.drop
  end
end

START_DBS = fetch_dbs

Mongoid.configure do |config|
  config.load_configuration(
    if Mongoid::VERSION >= '5'
      { clients: DB_CONFIG }
    else
      { sessions: DB_CONFIG }
    end
  )
end

require 'support/models'

Mongo::Logger.logger.level = Logger::INFO if Mongoid::VERSION >= '5'

RSpec.configure do |config|
  config.include Mongoid::Matchers

  config.before(:each) do
    Thread.current[:tenancy] = nil
    drop_shared
    # HACK: Mongoid.purge!
    [Journal, Blog, City].each(&:delete_all)
  end

  config.after(:each) do
    drop_shared
  end

  config.after(:suite) do
    puts "\n# With Mongoid v#{Mongoid::VERSION}"
    extra_dbs = (fetch_dbs - START_DBS) - ['mongoid_tenant_test']
    fail "Extra DBs: #{extra_dbs.inspect}" unless extra_dbs.empty?
  end
end
