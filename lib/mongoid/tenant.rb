require 'mongoid'
require 'mongoid/tenancy'

require 'mongoid/tenant/railtie' if defined?(Rails)

module Mongoid
  #
  # The tenant
  #
  module Tenant
    extend ActiveSupport::Concern

    included do
      store_in database: -> { Thread.current[:tenancy] }
    end
  end # Tenant
end # Mongoid
