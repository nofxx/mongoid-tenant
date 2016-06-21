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
      store_in database: lambda do
        Thread.current[:tenancy] || raise('No tenancy set!')
      end

      def tenancy
        Thread.current[:tenancy]
      end
    end
  end # Tenant
end # Mongoid
