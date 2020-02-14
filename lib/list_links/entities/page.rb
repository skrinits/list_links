class Page < Hanami::Entity
  URL_FORMAT = /(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})/

  attributes do
    attribute :id, Types::Int
    attribute :title, Types::String
    attribute :status, Types::String
    attribute :url, Types::String.constrained(format: URL_FORMAT)
  end
end
