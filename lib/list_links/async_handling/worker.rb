module AsyncHandling
  module Worker
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def perform_async(*args)
        AsyncHandling::Manager.instance.execute(self, args)
      end

      def wait
        AsyncHandling::Manager.instance.wait
      end
    end

    def perform(*args)
      raise NotImplementedError
    end

    def logger
      Hanami.logger
    end
  end
end
