module ApplicationHelper

  def logo 
    link_to image_tag('https://d1w11gv0j27jrz.cloudfront.net/symbol.png', class: "no-border-radius", width: 20, alt: 'symbol'), root_path, data: {turbo: false}
  end 

 

  def get_current_url
    request.original_url
  end

  def dev_images(image_name)
    if Rails.env.development? || Rails.env.test?
      image_name
    else
      "#{Rails.application.credentials.cloudfront[:host]}/#{image_name}"
    end
  end 
  
  def ordinal_suffix(day)
    if (11..13).include?(day % 100)
      "th"
    else
      case day % 10
        when 1 then "st"
        when 2 then "nd"
        when 3 then "rd"
        else "th"
      end
    end
  end

  def formatted_date(date)
    date.strftime("%B #{date.day}#{ordinal_suffix(date.day)}, %Y")
  end 

 


  
  def user_full_name(user)
    "#{user.first_name.capitalize} #{user.last_name.capitalize}"
  end
 
  def batch_date_range(batch)
    formatted_date(batch.start_date) + " - " + formatted_date(batch.end_date)
  end 

  def formatted_created_at_date(date)
    date = DateTime.parse(date)
    date_ist = date.in_time_zone('Asia/Kolkata')
    date_ist.strftime('%-dth %B, %Y %H:%M %p IST')
  end

  def formatted_date_with_year(date)
    date = DateTime.parse(date)
    date.strftime('%B %-dth, %Y')
  end

  def formatted_date_of_birth(date)
    date = DateTime.parse(date)
    date.strftime('%d-%m-%Y')
  end

  def vishram
    vishram = Package.find_by(name: 'VishraM')
    programme_path(vishram)

  end 

  def page_title(title = nil)
    if title.present?
      content_for(:title) { title }
    else
      content_for?(:title) ? content_for(:title) : generate_title_from_url
    end
  end

  def generate_title_from_url
    controller_name = controller.controller_name
    action_name = controller.action_name

    if action_name == "index"
      title = controller_name.humanize
    else
      title = "#{action_name.humanize} - #{controller_name.humanize}"
    end

    title
  end

  def default_title
    "ArogyaM - The Wellness Center"
  end

  def find_consultation(user)
    
    user.case_sheets.last.online_consultation
    
  end

  def payment_complete?(online_consultation)
    online_consultation.payment_complete == true
  end

  def find_online_consultation(booking_date)
    booking_date.online_consultations.find_by(date: booking_date.date, start_time: booking_date.start_time, confirmed: true, cancelled: false)
  end

  def has_profile?(user)
    user&.user_profile.present?
  end

  

  def days_and_nights_duration(batch)
    "#{(batch.end_date - batch.start_date).to_i + 1} days, #{(batch.end_date - batch.start_date).to_i} nights"
  end 

  def vishraam_end_date(batch, duration)
    batch.start_date + duration.to_i
  end 

 

  

 
  
  

  
end
