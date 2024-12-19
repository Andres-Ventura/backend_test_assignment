Rails.application.config.cache_store = :redis_cache_store, {
  url: ENV['REDIS_URL'],
  expires_in: 15.minutes
}