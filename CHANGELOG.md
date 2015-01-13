### VERSION 1.0.0

* Feature
  * Add moderation_required?, clean!, delete and delete_query method to Store
  * Add general configuration
  * Add generator Rails for install configuration file
  * Add Search interface

* Bug fix
  * replace bad key `test_data` by `moderation:test_data`

* Refactoring
  * Remove true Redis on spec for RedisMock
  * Replace autoload by require_relative
  * Harmonize Storage constructor of InMemory and Redis
  * Refactoring adapters memory and redis, for keep DRY
  * Add Coercer
  * Extract deserialization

* Enhancements

* Backwards incompatible changes
  * Moderation class became a module, you need to call Moderation::Store.new instead of Moderation.new
  * Storage::InMemory.new became Adapters::MemoryAdapter.new
  * Storage::Redis.new became Adapters::RedisAdapter.new
  * All adapters take Hash on their constructors
    * Adapters::MemoryAdapter.new(limit: 10)
    * Adapters::RedisAdapter.new(limit: 10)

* Test
  * Add configuration for testing all storage backend.

* Deprecations

* Todos
  * Change all Hash incoming to symbolized keys
  * Make Query more powerfull
  * Add support of :constructor and :new_from_json on moderation_required?

* Extra

* Issues

[Owner Joel AZEMAR](https://github.com/joel)

[Full changes](https://github.com/joel/moderation/pull/?)

### VERSION 0.0.3

https://github.com/leejones/moderation/compare/v0.0.2...v0.0.3

### VERSION 0.0.2

https://github.com/leejones/moderation/compare/v0.0.1...v0.0.2

### VERSION 0.0.1

https://github.com/leejones/moderation/compare/2cc7670800bc6df477a2ce3e7852187c49749565...v0.0.1

* feature

* bug fix

* refactoring

* enhancements

* backwards incompatible changes

* deprecations

* todos

* extra

* issues
