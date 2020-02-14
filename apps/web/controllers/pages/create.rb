module Web
  module Controllers
    module Pages
      class Create
        include Web::Action
        accept :json

        params Class.new(Hanami::Action::Params) {
          predicate(:valid_links?, message: 'Неправильно задан урл') do |current|
            current.all? { |url| url =~ /(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})/  }
          end

          validations do
            required(:links) { valid_links? }
          end
        }

        def call(params)
          return unless params.valid?

          params[:links].each { |link| LinksHandler.perform_async(link) }

          LinksHandler.wait
        end
      end
    end
  end
end
