Rake::Task["db:mongoid:create_indexes"].clear
Rake::Task["db:mongoid:remove_undefined_indexes"].clear

namespace :db do
  namespace :mongoid do

    def get_tenancy
      ENV['TENANCY'] ||
        fail("Provide a tenancy model: `TENANCY=Foo #{ARGV.join}`")
    end

    task :create_indexes => [:environment, :load_models] do
      Rake::Task["db:mongoid:create_indexes"].clear
      Object.const_get(get_tenancy).all.each do |t|
        puts "Tenant #{t}"
        t.tenancy!
        ::Mongoid::Tasks::Database.create_indexes
      end
    end

    task :remove_undefined_indexes => [:environment, :load_models] do
      Object.const_get(get_tenancy).all.each do |t|
        puts "Tenant #{t}"
        t.tenancy!
        ::Mongoid::Tasks::Database.remove_undefined_indexes
      end
    end
  end
end
