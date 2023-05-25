class BookingDate < ApplicationRecord
  has_many :online_consultations, dependent: :destroy
  has_many :users, through: :online_consultations
  
  
  
  def self.generate_default_slots 
    (0..29).each do |days_from_now|
      date = Date.current + days_from_now.days
      next if date.sunday?
  
      slot_times = [["14:00", "14:30"], ["15:00", "15:30"]] # 2 PM to 2:30 PM and 3 PM to 3:30 PM
  
      slot_times.each do |slot|
        BookingDate.create!(
          date: date,
          start_time: slot[0],
          end_time: slot[1],
          available: true
        )
      end
    end

    AddDayWorker.perform_in(24.hours) unless already_queued? 
   end
  
 
  

  def self.generate_day_slots(date)
    if date.sunday?
      return
    end
  
    slot_times = [["14:00", "14:30"], ["15:00", "15:30"]] # 2 PM to 2:30 PM and 3 PM to 3:30 PM
  
    slot_times.each do |slot|
      BookingDate.create!(
        date: date,
        start_time: slot[0],
        end_time: slot[1],
        available: true
      )
    end
  end

  private 

  def self.already_queued?
    Sidekiq::Queue.new.any? { |job| job.klass == 'AddDayWorker' }
  end

end
