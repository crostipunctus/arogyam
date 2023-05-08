# app/workers/slot_generation_worker.rb

class SlotGenerationWorker
  include Sidekiq::Worker

  def perform
    BookingDate.generate_default_slots
    # Schedule the next job to run in 29 days
    self.class.perform_in(29.days)
  end
end
