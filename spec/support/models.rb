# A nice model for a blog!
class Journal
  include Mongoid::Document
  include Mongoid::Tenancy

  field :name
end

class Article
  include Mongoid::Document
  include Mongoid::Tenant
  field :title
  field :body
end
