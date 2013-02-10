# Moderation

Certain types of data are good to keep around, but only in moderation.

## Installation

Add this line to your application's Gemfile:

    gem 'moderation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moderation

## Usage

Moderation keeps a limited amount of data (25 objects by default) and has a few different configuration options for data storage and retrieval.

We'll use the example of storing recent visitors to a web site.

    require 'ostruct'
    require 'json'

    class Visitor < OpenStruct
      def to_json
        {:ip_address => ip_address, :visited_url => visited_url}.to_json
      end
    end

### Default in-memory storage

    recent_visitors = Moderation.new(limit: 3)
    5.times do |n|
      new_visitor = Visitor.new(:ip_address => "222.333.44#{n}", :visited_url => 'http://example.com')
      recent_visitors.insert(new_visitor)
    end
    recent_visitors.all.map(&:ip_address)
    => ["222.333.445", "222.333.444", "222.333.443"]

We configured Moderation with `:limit => 3` so only the 3 most recent visitors are kept in storage.

### Redis storage

You can also store your objects with moderation. Each object will be stored as JSON, so you'll need to ensure that your object responds to `to_json` with a string of valid JSON that can be parsed when your object is retrieved from storage. Your object will also need to be able to be constructed from a hash of attributes (see "Custom constructors" otherwise).

    visitors = Moderation.new(limit: 3, storage: redis, constructor: Visitor)
    new_visitor = Visitor.new(:ip_address => '222.333.444.555', :url_visited => 'http://example.com/')
    visitors.insert(new_visitor)
    visitors.all.first
     => #<Visitor:0x00000101a15ef8 @ip_address="222.333.444.555", @url_visited="http://example.com/"> 

### Custom constructors

If your object does not initialize from a hash of attributes you can pass in the `:contruct_with` option and parse the JSON yourself. For example, if we had a Note class:

    require 'json'

    class Note
      attr_reader :title, :content

      def initialize(title, content)
        @title = title
        @content = content
      end

      def to_json
        {:title => title, :content => content}
      end

      def self.new_from_json(json)
        data = JSON.parse(json)
        new(data['title'], data['content'])
      end
    end

Then we could configure moderation to use the `new_from_json` constructor method:

    notes = Moderation.new(:limit => 3, :constructor => Note, :construct_with => :new_from_json)
    notes.insert(Note.new('A note title', 'Some note content')
    notes.all.first
    => #<Note:0x0000010095fb40 @title="A note title", @content="Some note content"> 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO

- [] add specs for memory store
- [] use yajl
- [] add redis storage backend
- [] document creating new storage backends

