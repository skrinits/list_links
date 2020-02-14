module Web
  module Controllers
    module Pages
      class Index
        include Web::Action
        expose :pages

        def call(params)
          @pages = PageRepository.new.all
        end
      end
    end
  end
end
