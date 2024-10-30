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
        origins 'http://localhost:54593/'
        resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head], max_age: 7200
      end
    end

    config.autoload_paths << Rails.root.join('app/lib') # app/libも追加
  end
end
