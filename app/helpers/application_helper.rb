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
    date.strftime("%B #{date.day}#{ordinal_suffix(date.day)}")
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
end
