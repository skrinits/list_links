require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require_relative '../lib/list_links'
require_relative '../apps/web/application'
require 'hanami/middleware/body_parser'

Hanami.configure do
  mount Web::Application, at: '/'

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/list_links_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/list_links_development'
    #    adapter :sql, 'mysql://localhost/list_links_development'
    #
    adapter :sql, ENV.fetch('DATABASE_URL')

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  mailer do
    root 'lib/list_links/mailers'

    # See https://guides.hanamirb.org/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: https://guides.hanamirb.org/projects/logging
    logger level: :debug
  end

  environment :production do
    logger level: :info, formatter: :json, filter: []

    mailer do
      delivery :smtp, address: ENV.fetch('SMTP_HOST'), port: ENV.fetch('SMTP_PORT')
    end
  end

  middleware.use Hanami::Middleware::BodyParser, :json
end
