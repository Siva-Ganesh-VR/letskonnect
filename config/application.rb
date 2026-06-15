require_relative "boot"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Letskonnect
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Configuration for the application, engines, and railties goes here.
    config.autoload_lib(ignore: %w[assets tasks])

    config.time_zone = "UTC"
    config.i18n.default_locale = :en

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
