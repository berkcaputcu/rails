# frozen_string_literal: true

require "cases/helper"
require "models/book"

module ActiveRecord
  class InstrumentationTest < ActiveRecord::TestCase
    def setup
      ActiveRecord::Base.connection.schema_cache.add(Book.table_name)
    end

    def test_payload_name_on_load
      Book.create(name: "test book")
      subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        if event.payload[:sql].match "SELECT"
          assert_equal "Book Load", event.payload[:name]
        end
      end
      Book.first
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end

    def test_payload_name_on_create
      subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        if event.payload[:sql].match "INSERT"
          assert_equal "Book Create", event.payload[:name]
        end
      end
      Book.create(name: "test book")
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end

    def test_payload_name_on_update
      subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        if event.payload[:sql].match "UPDATE"
          assert_equal "Book Update", event.payload[:name]
        end
      end
      book = Book.create(name: "test book", format: "paperback")
      book.update_attribute(:format, "ebook")
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end

    def test_payload_name_on_calculate
      subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        if event.payload[:sql].match "COUNT"
          assert_equal "Book Count", event.payload[:name]
        end
      end
      Book.calculate(:count, :all)
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end

    def test_payload_name_on_average
      subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        if event.payload[:sql].match "AVG"
          assert_equal "Book Average", event.payload[:name]
        end
      end
      Book.average(:id)
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end

    def test_payload_name_on_count
      subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        if event.payload[:sql].match "COUNT"
          assert_equal "Book Count", event.payload[:name]
        end
      end
      Book.count
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end

    def test_payload_name_on_maximum
      subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        if event.payload[:sql].match "MAX"
          assert_equal "Book Maximum", event.payload[:name]
        end
      end
      Book.maximum(:id)
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end

    def test_payload_name_on_minimum
      subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        if event.payload[:sql].match "MIN"
          assert_equal "Book Minimum", event.payload[:name]
        end
      end
      Book.minimum(:id)
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end

    def test_payload_name_on_sum
      subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        if event.payload[:sql].match "SUM"
          assert_equal "Book Sum", event.payload[:name]
        end
      end
      Book.sum(:id)
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end

    def test_payload_name_on_update_all
      subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        if event.payload[:sql].match "UPDATE"
          assert_equal "Book Update All", event.payload[:name]
        end
      end
      Book.create(name: "test book", format: "paperback")
      Book.update_all(format: "ebook")
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end

    def test_payload_name_on_destroy
      subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        if event.payload[:sql].match "DELETE"
          assert_equal "Book Destroy", event.payload[:name]
        end
      end
      book = Book.create(name: "test book")
      book.destroy
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end
  end
end
