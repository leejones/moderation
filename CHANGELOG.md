### VERSION 1.0.0

* Feature
  * Add moderation_required? and clean! method to Store
  * Add general configuration
  * Add generator Rails for install configuration file
  * Add Search interface

* Bug fix
  * replace bad key `test_data` by `moderation:test_data`

* Refactoring
  * Add interface AbstractStorage and AbstractCoercer
  * Remove true Redis on spec for RedisMock
  * Replace autoload by require_relative
  * Harmonize Storage constructor of InMemory and Redis
  * Refactoring adapters memory and redis, for keep DRY

* Enhancements
  * Add policy of coercion, you can pass your own coercer
  * Pass coercer to search (adapters)

* Backwards incompatible changes
  * Moderation class became a module, you need to call Moderation::Store.new instead of Moderation.new
  * Signature of Moderation::Storage::InMemory has changed, it take Hash now
    * Moderation::Storage::InMemory.new(limit: 10)

* Test
  * Add configuration for testing all storage backend.

* Deprecations

* Todos

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
