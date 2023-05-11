class BookingDate < ApplicationRecord

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
  end
  

  def self.generate_day_slots(date)
    start_hour = 14 # 2 PM
    end_hour = 16 # 4 PM
    slot_duration_minutes = 30
  
    return if date.sunday?
  
    start_time = start_hour * 60
    end_time = end_hour * 60
    (start_time...end_time).step(slot_duration_minutes) do |slot_start_minutes|
      slot_start_time = Time.zone.at(slot_start_minutes * 60).strftime("%H:%M")
      slot_end_time = Time.zone.at((slot_start_minutes + slot_duration_minutes) * 60).strftime("%H:%M")
  
      BookingDate.create!(
        date: date,
        start_time: slot_start_time,
        end_time: slot_end_time,
        available: true
      )
    end
  end

end
