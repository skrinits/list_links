module Web
  module Views
    module Pages
      class Create
        include Web::View

        format :json

        def render
          result = if params.valid?
                     { success: true }
                   else
                     { errors: params.errors.values.flatten }
                   end

          raw(result.to_json)
        end
      end
    end
  end
end
