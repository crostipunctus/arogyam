Sentry.init do |config|
  config.dsn = 'https://676e8f492a4f40c0ab87b1070d134f96@o4505542864470016.ingest.sentry.io/4505542865911808'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end