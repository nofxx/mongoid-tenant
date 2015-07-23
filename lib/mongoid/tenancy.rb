module Mongoid
  #
  # Tenancy Module
  #
  # Provides #tenant_key and #tenancy!
  #
  module Tenancy
    extend ActiveSupport::Concern
    #
    # Model instance
    module ClassMethods
      def tenant_key(key, options = {})
        field key,    type: Symbol
        options[:validates] ||= { presence: true }
        options[:index] ||= {}

        validates key, { uniqueness: true }.merge(options[:validates])

        index({ key => 1 }, {  unique: true }.merge(options[:index]))

        define_method(:tenant_key) do
          send(key).to_s
        end
      end

      def has_tenant(relative)
        define_method(relative) do
          tenancy! && relative.to_s.classify.constantize
        end
      end
    end

    def tenants
      self.class.all.each do |t|
        t.tenancy!
        yield t
      end
    end

    def tenancy!
      Thread.current[:tenancy] = tenant_key
    end
  end # Tenancy
end # Mongoid
