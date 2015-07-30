Mongoid::Tenant
===============

[![Gem Version](https://badge.fury.io/rb/mongoid-tenant.svg)](http://badge.fury.io/rb/mongoid-tenant)
[![Dependency Status](https://gemnasium.com/nofxx/mongoid-tenant.svg)](https://gemnasium.com/nofxx/mongoid-tenant)
[![Build Status](https://secure.travis-ci.org/nofxx/mongoid-tenant.svg)](http://travis-ci.org/nofxx/mongoid-tenant)
[![Code Climate](https://codeclimate.com/github/nofxx/mongoid-tenant/badges/gpa.svg)](https://codeclimate.com/github/nofxx/mongoid-tenant)
[![Coverage Status](https://coveralls.io/repos/nofxx/mongoid-tenant/badge.svg?branch=master&service=github)](https://coveralls.io/github/nofxx/mongoid-tenant?branch=master)

## Mongoid::Tenant

Simple multi tenant for mongoid models!


## Nice Tenancy for Mongoid Documents

This library is a simple way to split your client data between databases.
To mongo it's pretty trivial to use multiple databases. Mongoid helps too.

Supposing you have a Bike SaaS where each Shop stores:

## Tenancy

```
class Shop
  include Mongoid::Document
  include Mongoid::Tenancy

  tenant_key :url
end
```

## Tenant


```
class Bike
  include Mongoid::Document
  include Mongoid::Tenant
end
```

And that's all.


## Helpers


Codebase is really is small. Check lib/

### Tenancy#tenancy!

Helper to set the current namespace.

```
Shop.first.tenancy!
```

### Tenancy.tenants

Helper to execute something on each tenant namespace.
has_many substitute. Eg:

```
class Shop
   ...
   has_tenant :bikes
end
```

Or raw:

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


## Issues

http://github.com/nofxx/mongoid-tenant
