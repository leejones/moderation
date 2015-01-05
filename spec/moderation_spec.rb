require 'spec_helper'

require 'ostruct'
# require 'json'

module Moderation
  describe Store do
    it 'keeps a limited amount of data' do
      recent_visitors = Store.new(limit: 3, constructor: Visitor)
      5.times do |n|
        visitor = Visitor.new(ip_address: "222.333.44#{n}")
        recent_visitors.insert(visitor)
      end
      recent_visitors.all.count.should eql(3)
    end

    it 'keeps the most recently stored objects' do
      recent_visitors = Store.new(limit: 3, constructor: Visitor)
      5.times do |n|
        visitor = Visitor.new(ip_address: "222.333.44#{n}")
        recent_visitors.insert(visitor)
      end
      recent_visitors.all.map(&:ip_address).should eql(["222.333.444", "222.333.443", "222.333.442"])
    end

    it 'retrieves objects you stored' do
      notes = Store.new(limit: 3, constructor: Note)
      stored_note = Note.new(title: 'A Title', content: 'Some content')
      notes.insert(stored_note)
      retrieved_note = notes.all.first
      retrieved_note.title.should eql('A Title')
      retrieved_note.content.should eql('Some content')
    end

    it 'limits the number of results returned' do
      notes = Store.new(limit: 3, constructor: Note)
      (0..5).to_a.each do |n|
        note = Note.new(title: "Title #{n}", content: "Content #{n}")
        notes.insert(note)
      end
      notes.all(limit: 2).count.should eql(2)
    end

    it 'uses a custom contructor' do
      books = Store.new(constructor: Book, construct_with: :new_from_json)
      new_book = Book.new('Title Goes Here', 'Author Name')
      books.insert(new_book)
      retrieved_book = books.all.first
      [retrieved_book.title, retrieved_book.author].should eql(['Title Goes Here', 'Author Name'])
    end

    it 'stores a limited amount of data in redis' do
      redis_storage = Moderation::Storage::Redis.new(collection: 'rows')
      rows = Store.new(limit: 33, storage: redis_storage)
      50.times { |n| rows.insert [n] }
      rows.all.count.should eql(33)
    end

    private

    class Visitor < OpenStruct
      def to_json(*a)
        { ip_address: ip_address }.to_json
      end
    end

    class Note < OpenStruct
      def to_json(*a)
        {
          title: title,
          content: content
        }.to_json
      end
    end

    class Book
      attr_reader :title, :author

      def initialize(title, author)
        @title = title
        @author = author
      end

      def to_json(*a)
        { title: title, author: author }.to_json(a)
      end

      def self.new_from_json(json)
        data = JSON.parse(json, symbolize_names: true)
        new(data[:title], data[:author])
      end
    end
  end
end
