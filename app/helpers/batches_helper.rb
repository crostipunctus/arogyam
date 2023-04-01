module BatchesHelper
  def nearest_batch(batches) 
    nearest_batch = batches.min_by { |batch| (batch.start_date - Date.today).abs }
  end 

  def is_nearest_batch(batch, batches)
    batch == nearest_batch(batches)
  end

  def is_user_registered_for_batch?(user, batch)
    user.batches.include?(batch)
  end
end
