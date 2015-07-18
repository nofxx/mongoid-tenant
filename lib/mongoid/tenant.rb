require 'mongoid'
require_relative 'tenancy'

require 'mongoid/tenant/railtie' if defined?(Rails)

module Mongoid
  module Tenant
    extend ActiveSupport::Concern

    included do
      store_in database: -> { Thread.current[:mongodb] }
    end
  end # Tenant
end # Mongoid
