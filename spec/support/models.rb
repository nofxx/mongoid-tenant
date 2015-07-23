# A nice model for jornalistic SaaS!
class Journal
  include Mongoid::Document
  include Mongoid::Tenancy

  field :name
  tenant_key :url

  has_tenant :articles
end

# Reporter -> Journal tenant
class Reporter
  include Mongoid::Document
  include Mongoid::Tenant

  field :name
end

# Article -> Journal tenant
class Article
  include Mongoid::Document
  include Mongoid::Tenant

  field :title
  field :body
end

# City normal model
class City
  include Mongoid::Document
  field :name
end

class Blog
  include Mongoid::Document
  include Mongoid::Tenancy
  field :name
  tenant_key :url, validates: { allow_nil: true }, index: { sparse: true }

  has_tenant :articles
end
