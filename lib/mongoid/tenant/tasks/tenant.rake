Rake::Task['db:mongoid:create_indexes'].clear
Rake::Task['db:mongoid:remove_indexes'].clear
Rake::Task['db:mongoid:remove_undefined_indexes'].clear

namespace :db do
  namespace :mongoid do
    def tenancy_env
      ENV['TENANCY'] && !ENV['TENANCY'].empty? ? ENV['TENANCY'] : nil
    end

    def tenancy_models
      ::Mongoid.models.select { |k| k.include?(::Mongoid::Tenant) }
    end

    def non_tenancy_models
      ::Mongoid.models.reject { |k| k.include?(::Mongoid::Tenant) }
    end

    def puts_warning
      puts 'Not running tenants... Provide a tenancy model:'
      puts "`TENANCY=Model #{ARGV.join(' ')}`"
    end

    desc 'Create Mongoid indexes, tenant aware'
    task create_indexes: %i[environment load_models] do
      # Run once, for tables outside tenancy
      ::Mongoid::Tasks::Database.create_indexes(non_tenancy_models)
      if tenancy_env
        Object.const_get(tenancy_env).active_tenants.each do |t|
          puts "Tenant #{t}"
          t.tenancy!
          ::Mongoid::Tasks::Database.create_indexes(tenancy_models)
        end
      else
        puts_warning
      end
    end

    desc 'Remove Mongoid indexes, tenant aware'
    task remove_indexes: %i[environment load_models] do
      # Run once, for tables outside tenancy
      ::Mongoid::Tasks::Database.remove_indexes(non_tenancy_models)
      if tenancy_env
        Object.const_get(tenancy_env).active_tenants.each do |t|
          puts "Tenant #{t}"
          t.tenancy!
          ::Mongoid::Tasks::Database.remove_indexes(tenancy_models)
        end
      else
        puts_warning
      end
    end

    desc 'Removes undefined Mongoid indexes, tenant aware'
    task remove_undefined_indexes: %i[environment load_models] do
      # Run once, for tables outside tenancy
      ::Mongoid::Tasks::Database.remove_undefined_indexes(non_tenancy_models)
      if tenancy_env
        Object.const_get(tenancy_env).active_tenants.each do |t|
          puts "Tenant #{t}"
          t.tenancy!
          ::Mongoid::Tasks::Database.remove_undefined_indexes(tenancy_models)
        end
      end
    end
  end
end
