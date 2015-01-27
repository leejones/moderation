# Moderation

Certain types of data are good to keep around, but only in moderation.

## Installation

Add this line to your application's Gemfile:

    gem 'moderation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moderation

### Configuration

You can add a configuration file on your Rails project under this directory

add file `config/initializers/moderation.rb`

You can use the Rails generator for this

`rails generate moderation:install`

You can change global configuration here

```
Moderation.configure do |conf|
  # conf.limit = 25 # default: 25
end
```

## Usage

Moderation stores the most recent data based on a limit you set (25 objects by default). Moderation can store the data in Redis or in-memory.

### Possible use cases

* admin dashboards and event streams
* user activity (signups, purchases, favorites)
* user search history
* processing failures
* visitor ip addresses
* sent emails
* incoming emails
* referring pages/domains

### Initialization Options

Moderation initializes with a Hash of options:

    Moderation::Store.new(options = {})

**options**

* `:limit` - integer that determines how many objects Moderation will keep before deleting old objects (default: 25)
* `:storage` - an instance of a storage object (default: in-memory)
* `:constructor` - optional, class used to initialize new objects when fetching data from storage
* `:construct_with` - optional, symbol for the method to call on the `:constructor`

Example:

    redis_storage = Adapters::RedisAdapter.new(
      collection: 'visitors',
      server: redis
    )

    website_visitors = Moderation::Store.new(
      :limit => 50,
      :storage => redis_storage,
      :constructor => Visitor,
      :construct_with => :new_from_json
    )

### Interface Moderation::Adapters::Abstract

**insert(item)**

* `item` - object, stored as JSON
  * Hash
  * Array
  * Other objects
* returns `nil`

Example:

    new_visitor = Visitor.new('223.123.243.11', 'http://example.com/')
    website_visitors.insert(new_visitor)

**all(options = {})**

* `options` - optional, a Hash of parameters
  * `:limit` - specifies the max number of objects that are fetched from storage (default: 25)
* returns an Array of objects

Examples (after a couple more people visited the website):

    website_visitors.all
    => [#<Visitor ip_address="223.123.243.11", visited_url="http://example.com">, #<Visitor ip_address="123.443.243.11", visited_url="http://example.com/about">, #<Visitor ip_address="292.122.155.11", visited_url="http://example.com/contact">]

    website_visitors.all(:limit => 1)
    => [#<Visitor ip_address="223.123.243.11", visited_url="http://example.com">]

**moderation_required?**

  if you have some moderation on your observed model, you can ask simply the store about that, optionally you can pass query like that:

  moderation_required? :ip_address, '223.123.243.11'

**clean!**

  After your moderation you can cleanup your pending moderation

#### Storing Hash or Array objects

Example:

    temperatures = Moderation::Store.new

    # add some data
    (1..28).to_a.each do |n|
      high = rand(100)
      temperature = {
        :date => "2013-02-#{n}",
        :high => "#{high}F",
        :low => "#{high - rand(20)}F"
      }
      temperatures.insert(temperature)
    end

    # keeps only the 25 most recent temperatures:
    temperatures.all.count
    => 25

    # the most recently added temperature is first:
    temperatures.all.first
    => {:date=>"2013-02-28", :high=>"89F", :low=>"72F"}

#### Storing other types of objects

Other types of objects need to meet 2 requirements:

  * respond to `to_json(*a)` with a string that can be later used to reconstruct the object
  * initialize with a hash of attributes (see “Custom constructors” if you need a different way to initialize your objects)

For this example we’ll create a simple object to represent a user's recent search history:

    require 'ostruct'
    require 'json'

    class UserSearch < OpenStruct
      def to_json(*a)
        {:term => term, :user => user, :result_count => result_count}.to_json(*a)
      end
    end

Now we can setup moderation and store new searches using the `:constructor` option:

    user_search_history = Moderation::Store.new(
      :limit => 50,
      :constructor => UserSearch
    )

Our search controller might look something like:

    search = UserSearch.new(
      :user => current_user.id,
      :term => params[:q],
      :result_count => results.count
    )
    user_search_history.insert(search)

We configured `user_search_history` with `:limit => 50` so only the 50 most recent searches are kept in storage.

#### Custom constructors

If your object does not initialize from a hash of attributes you can pass in the `:contruct_with` option and parse the JSON yourself. For example, if we had a Note class:

    require 'json'

    class Note
      attr_reader :title, :content

      def initialize(title, content)
        @title = title
        @content = content
      end

      def to_json(*a)
        {:title => title, :content => content}.to_json(*a)
      end

      def self.new_from_json(json)
        data = JSON.parse(json)
        new(data['title'], data['content'])
      end
    end

Then we could configure moderation to use the `new_from_json` constructor method:

    notes = Moderation::Store.new(
      :limit => 3,
      :constructor => Note,
      :construct_with => :new_from_json
    )

### Storage

#### Redis storage

Moderation can use a Redis storage backend. You'll want to pass in a `:collection` which is a string that gets used as the storage key in Redis. We're using a Redis list to store the data.

    require 'redis'
    redis = Redis.new
    redis_storage = Adapters::RedisAdapter.new(
      :collection => 'recent_visitors',
      :server => redis
    )

Then setup moderation with the `:storage` option:

    recent_visitors = Moderation::Store.new(
      :limit => 50,
      :constructor => Visitor,
      :construct_with => :new_from_json,
      :storage => redis_storage
    )

#### In-memory storage

Moderation stores data in-memory by default.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Test

For execute full test suite you can run the following command:

`rake`
or
`rake spec_all`

## TODO

- [] document creating new storage backends
