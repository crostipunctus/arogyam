# config/initializers/slot_generation_scheduler.rb

# Schedule the first job only if it's not already scheduled
unless Sidekiq::ScheduledSet.new.find { |job| job.klass == 'SlotGenerationWorker' }
  SlotGenerationWorker.perform_async
end
