# Upgrading

# Upgrading from 0.0.3 to 1.0.0

You need to rename `Moderation.new` to `Moderation:Store.new`

You need to rename `Storage::InMemory.new` to `Adapters::MemoryAdapter.new`

You need to rename `Storage::Redis.new` to `Adapters::RedisAdapter.new`
