# frozen_string_literal: true

Unsplash.configure do |config|
  config.application_access_key = ENV.fetch("UNSPLASH_ACCESS_KEY")
  config.application_secret = ENV.fetch("UNSPLASH_SECRET_KEY")
end
