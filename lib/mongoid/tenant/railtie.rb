module Rails
  module Mongoid::Tenant
    class Railtie < Rails::Railtie
      rake_tasks do
        load "mongoid/tenant/tasks/tenant.rake"
      end

    end
  end
end
