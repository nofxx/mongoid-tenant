Mongoid::Tenant
===============

[![Gem Version](https://badge.fury.io/rb/mongoid-tenant.png)](http://badge.fury.io/rb/mongoid-tenant)
[![Dependency Status](https://gemnasium.com/nofxx/mongoid-tenant.svg)](https://gemnasium.com/nofxx/mongoid-tenant)
[![Build Status](https://secure.travis-ci.org/nofxx/mongoid-tenant.png)](http://travis-ci.org/nofxx/mongoid-tenant)

## Mongoid::Tenant

Simple multi tenant for mongoid models!


## Nice Tenancy for Mongoid Documents

This library is a simple way to split your client data between databases.
To mongo it's pretty trivial to use multiple databases. Mongoid helps too.

## Tenant

Models to be splitted, supposing you have a Bike SaaS where each Shop stores
their bikes:

```
class Bike
  include Mongoid::Document
  include Mongoid::Tenant
end
```

And that's all. But we need a tenancy:

## Tenancy

```
class Shop
  include Mongoid::Document
  include Mongoid::Tenancy
end
```


## Helpers


Codebase is really is small. Check lib/

### Tenancy#tenancy!

Helper to set the current namespace.

```
Shop.first.tenancy!
```

### Tenancy.tenants

Helper to execute something on each tenant namespace. Eg:

```
Shop.tenants { |tenant| puts "#{tenant} have #{Bike.count} bike(s)" }
```


### Rake Tasks

Index creation is the only thing overwriten in Mongoid.
You'll need to provide which Tenancy to scope. In our example:

```
TENANCY=Shop bundle exec rails db:mongoid:create_indexes
```

## ApplicationController

Write your logic:

```
def app_domain
  @domain ||= Shop.find_by(uri: /^#{request.env["SERVER_NAME"]}/)
  @domain.tenancy!
end
```
