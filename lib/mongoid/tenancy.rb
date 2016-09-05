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
        field key, type: Symbol

        options[:validates] ||= { presence: true }
        options[:index] ||= {}

        validates key, { uniqueness: true }.merge(options[:validates])
        index({ key => 1 }, { unique: true }.merge(options[:index]))
        scope :active_tenants, -> { where(key.ne => nil) }

        define_method(:tenant_key) do
          send(key).to_s
        end

        define_singleton_method(:clear_tenancy!) do
          Thread.current[:tenancy] = nil
        end

        define_singleton_method(:with_tenants) do |&block|
          all.each do |t|
            t.tenancy!
            block.call(t)
          end
          clear_tenancy!
        end
      end

      def has_tenant(relative)
        define_method(relative) do
          tenancy! && relative.to_s.classify.constantize
        end
      end
    end

    def tenancy!
      Thread.current[:tenancy] = tenant_key
    end
  end # Tenancy
end # Mongoid
