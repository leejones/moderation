class Moderation
  class Storage
    autoload 'InMemory', 'moderation/storage/in_memory.rb'
    autoload 'Redis', 'moderation/storage/redis.rb'
  end
end
