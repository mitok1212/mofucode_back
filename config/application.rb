require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MofucodeBack
  class Application < Rails::Application
    # other configurations

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://10.0.2.2:3000'
        resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head], max_age: 7200
      end
    end

    # other configurations
  end
end
