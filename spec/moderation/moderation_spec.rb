require 'spec_helper'

require 'ostruct'
# require 'json'

module Moderation
  describe Store do
    context "Adapter #{ENV['ADAPTER']}" do
      let(:options)       { Adapter.new(ENV['ADAPTER']).options(store_options) }
      let(:store)         { Store.new(options) }
      let(:store_options) {{}}

      let(:recent_visitors) { store }

      context 'without records' do
        specify '#moderation_required?' do
          expect(recent_visitors.moderation_required?).to be_falsey
        end
      end

      context 'with records' do
        before do
          recent_visitors.insert({ip_address: '222.333.44.01'})
          recent_visitors.insert({ip_address: '222.333.44.02'})
          recent_visitors.insert({ip_address: '222.333.44.02'})
          recent_visitors.insert({ip_address: '222.333.44.02'})
        end

        specify '#moderation_required?' do
          expect(recent_visitors.moderation_required?).to be_truthy
          expect(recent_visitors.moderation_required?(:ip_address, '222.333.44.01')).to be_truthy
          expect(recent_visitors.moderation_required?(:ip_address, '222.333.44.00')).to be_falsey
        end

        context '#clean!' do
          before { store.clean! }
          specify do
            expect(recent_visitors.moderation_required?).to be_falsey
          end
        end

        specify '#search' do
          expect(recent_visitors.search(:ip_address, '222.333.44.01').size).to eql(1)
        end

        describe '#delete' do
          context 'without search' do
            specify do
              expect(recent_visitors.delete({ip_address: '222.333.44.01'})).to eql(1)
              expect(recent_visitors.all.size).to eql(3)
            end
          end
          context 'with search' do
            specify do
              expect(recent_visitors.delete_query(:ip_address, '222.333.44.02')).to eql(3)
              expect(recent_visitors.all.size).to eql(1)
            end
          end
        end
      end

      context 'with 3 Visitors' do
        let(:store_options) {{limit: 3, constructor: Visitor}}
        let(:recent_visitors) { store }

        it 'keeps a limited amount of data' do
          5.times do |n|
            visitor = Visitor.new(ip_address: "222.333.44#{n}")
            recent_visitors.insert(visitor)
          end
          recent_visitors.all.count.should eql(3)
        end

        it 'keeps the most recently stored objects' do
          5.times do |n|
            visitor = Visitor.new(ip_address: "222.333.44#{n}")
            recent_visitors.insert(visitor)
          end
          recent_visitors.all.map(&:ip_address).should eql(["222.333.444", "222.333.443", "222.333.442"])
        end
      end

      context 'with 3 Notes' do
        let(:store_options) {{limit: 3, constructor: Note}}
        let(:notes) { store }

        it 'retrieves objects you stored' do
          stored_note = Note.new(title: 'A Title', content: 'Some content')
          notes.insert(stored_note)
          retrieved_note = notes.all.first
          retrieved_note.title.should eql('A Title')
          retrieved_note.content.should eql('Some content')
        end

        it 'limits the number of results returned' do
          (0..5).to_a.each do |n|
            note = Note.new(title: "Title #{n}", content: "Content #{n}")
            notes.insert(note)
          end
          notes.all(limit: 2).count.should eql(2)
        end
      end

      context 'with Book and custom constructor' do
        let(:store_options) {{constructor: Book, construct_with: :new_from_json}}
        let(:books) { store }

        it 'uses a custom contructor' do
          new_book = Book.new('Title Goes Here', 'Author Name')
          books.insert(new_book)
          retrieved_book = books.all.first
          [retrieved_book.title, retrieved_book.author].should eql(['Title Goes Here', 'Author Name'])
        end
      end

      # it 'stores a limited amount of data in redis', skip: true do
      #   redis_storage = Redis.new(collection: 'rows')
      #   rows = Store.new(limit: 33, storage: redis_storage)
      #   50.times { |n| rows.insert [n] }
      #   rows.all.count.should eql(33)
      # end

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

        def self.new_from_json(data)
          new(data[:title], data[:author])
        end
      end
    end
  end
end
