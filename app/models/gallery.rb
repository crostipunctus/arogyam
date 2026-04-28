

  class Gallery < ApplicationRecord
    has_many_attached :images do |attachable|
      attachable.variant :thumb, resize_to_limit: [800, 600],   saver: { quality: 80 }
      attachable.variant :large, resize_to_limit: [1600, 1200], saver: { quality: 82 }
    end
  
    
  end
  

  

