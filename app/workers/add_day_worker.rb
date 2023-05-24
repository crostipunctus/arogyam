class AddDayWorker
  include Sidekiq::Worker

  def perform
    # Add a day of slots
    BookingDate.generate_day_slots(Date.current + 30.days)

    # Schedule this worker to run again in 24 hours
    AddDayWorker.perform_in(24.hours)
  end
end
