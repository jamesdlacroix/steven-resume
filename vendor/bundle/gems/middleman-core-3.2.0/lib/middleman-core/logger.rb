# Use the Ruby/Rails logger
require 'active_support/notifications'
require 'active_support/buffered_logger'
require 'thread'

module Middleman

  # The Middleman Logger
  class Logger < ActiveSupport::BufferedLogger
    def initialize(log_level=1, is_instrumenting=false, target=$stdout)
      super(target)

      self.level = log_level
      @instrumenting = is_instrumenting

      if @instrumenting != false
        ::ActiveSupport::Notifications.subscribe(/\.middleman$/, self)
      end

      @mutex = Mutex.new
    end

    def add(*args)
      @mutex.synchronize do
        super
      end
    end

    def call(message, *args)
      return if @instrumenting.is_a?(String) && @instrumenting != "instrument" && !message.include?(@instrumenting)

      evt = ActiveSupport::Notifications::Event.new(message, *args)
      self.info "== Instrument (#{evt.name.sub(/.middleman$/, '')}): #{evt.duration}ms"
    end
  end
end