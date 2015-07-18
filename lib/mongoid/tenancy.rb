module Mongoid
  module Tenancy
    extend ActiveSupport::Concern

    included do
      field :uri,     type: String

      validates :uri, uniqueness: true

      index({ uri: 1 }, unique: true)

      def self.tenants
        all.each do |t|
          t.tenancy!
          yield t
        end
      end
    end

    def tenancy!
      Thread.current[:mongodb] = _id.to_s
    end
  end # Tenancy
end # Mongoid
