module Rails
  module Mongoid
    module Tenant
      # Load rake tasks
      # MongoDB Indexes
      class Railtie < Rails::Railtie
        rake_tasks do
          load 'mongoid/tenant/tasks/tenant.rake'
        end
      end
    end # Tenant
  end # Mongoid
end # Rails
