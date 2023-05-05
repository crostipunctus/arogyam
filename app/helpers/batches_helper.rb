module BatchesHelper
  def nearest_batch(batches) 
    nearest_batch = batches.min_by { |batch| (batch.start_date - Date.today).abs }
  end 

  def is_nearest_batch(batch, batches)
    batch == nearest_batch(batches)
  end

  def show_registered?(user, batch)
    registration = Registration.find_by(user: user, batch: batch)
    if registration.present? && registration.status == "Registered" || registration.present? && registration.completed == false
      return true
    else
      false
    end
  end

  def batch_date_range(batch)
    formatted_date(batch.start_date) + " - " + formatted_date(batch.end_date)
  end 
end
