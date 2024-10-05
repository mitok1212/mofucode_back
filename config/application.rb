require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MofucodeBack
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    # 例外をキャッチしてカスタムルーティングに委譲
    
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://10.0.2.2:3000'

        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head]
          #credentials: true  #クッキーを含む認証情報を許可する場合
          config.exceptions_app = self.routes
      end
    end
    config.api_only = true
  end
end
