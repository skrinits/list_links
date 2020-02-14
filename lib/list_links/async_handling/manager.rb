module AsyncHandling
  class Manager
    include Singleton

    def initialize
      @threads = []
    end

    def execute(handler_klass, args)
      if Hanami.env == 'test'
        perform(handler_klass, args)
      else
        @threads << Thread.new { perform(handler_klass, args) }
      end
    end

    def wait
      @threads.each { |thread| thread.join }
    end

    private

    def perform(handler_klass, args)
      handler_klass.new.perform(*args)
    end
  end
end
