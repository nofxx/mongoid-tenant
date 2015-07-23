Rake::Task['db:mongoid:create_indexes'].clear
Rake::Task['db:mongoid:remove_undefined_indexes'].clear

namespace :db do
  namespace :mongoid do
    def tenancy_env
      ENV['TENANCY'] ||
        fail("Provide a tenancy model: `TENANCY=Foo #{ARGV.join}`")
    end

    desc 'Create Mongoid indexes, tenant aware'
    task create_indexes: [:environment, :load_models] do
      Rake::Task['db:mongoid:create_indexes'].clear
      Object.const_get(tenancy_env).all.each do |t|
        puts "Tenant #{t}"
        t.tenancy!
        ::Mongoid::Tasks::Database.create_indexes
      end
    end

    desc 'Removes undefined Mongoid indexes, tenant aware'
    task remove_undefined_indexes: [:environment, :load_models] do
      Object.const_get(tenancy_env).all.each do |t|
        puts "Tenant #{t}"
        t.tenancy!
        ::Mongoid::Tasks::Database.remove_undefined_indexes
      end
    end
  end
end