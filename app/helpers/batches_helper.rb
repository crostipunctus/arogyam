module BatchesHelper
  def nearest_batch(batches) 
    nearest_batch = batches.min_by { |batch| (batch.start_date - Date.today).abs }
  end 

  def is_nearest_batch(batch, batches)
    batch == nearest_batch(batches)
  end

  def user_registered_for_batch?(user, batch)
    Registration.exists?(user: user, batch: batch, status: "Registered")
  end

  def batch_date_range(batch)
    formatted_date(batch.start_date) + " - " + formatted_date(batch.end_date)
  end 
end
