module Mongoid
  module Tenancy
    extend ActiveSupport::Concern

    module ClassMethods
      def tenant_key key, options = {}
        field key,    type: Symbol

        validates key, { uniqueness: true }.merge(options[:validates])

        index({ key => 1 }, {  unique: true }.merge(options[:index]))
      end
    end

    # included do

    #   def self.tenants
    #     all.each do |t|
    #       t.tenancy!
    #       yield t
    #     end
    #   end
    # end

    def tenancy!
      Thread.current[:tenancy] = _id.to_s
    end
  end # Tenancy
end # Mongoid
