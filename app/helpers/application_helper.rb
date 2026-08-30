module ApplicationHelper

  SITE_NAME = 'ArogyaM'.freeze
  SITE_DOMAIN = 'https://arogyam.life'.freeze

  def site_settings
    Setting.instance
  end
  DEFAULT_DESCRIPTION = 'ArogyaM is an Ayurvedic wellness center at Sacred Grove, Chowdepalli offering health programmes, yoga, Ayurveda treatments, and holistic healing retreats.'.freeze
  DEFAULT_IMAGE = 'https://d1w11gv0j27jrz.cloudfront.net/symbol.png'.freeze

  def default_meta_tags
    {
      site: SITE_NAME,
      title: 'The Wellness Center',
      reverse: true,
      separator: '|',
      description: DEFAULT_DESCRIPTION,
      keywords: 'Ayurveda, Yoga, Wellness, wellness center, Satsang Foundation, Chowdepalli, Sacred Grove, ArogyaM, Sri M, Ayurvedic treatment, health retreat, holistic healing',
      canonical: canonical_url,
      og: {
        site_name: SITE_NAME,
        title: :full_title,
        description: :description,
        type: 'website',
        url: canonical_url,
        image: DEFAULT_IMAGE
      },
      twitter: {
        card: 'summary_large_image',
        site: '@arogyam_life',
        title: :full_title,
        description: :description,
        image: DEFAULT_IMAGE
      }
    }
  end

  def logo
    link_to image_tag('https://d1w11gv0j27jrz.cloudfront.net/symbol.png', class: "no-border-radius", width: 20, alt: 'symbol'), root_path, data: {turbo: false}
  end

  def has_active_registration?(user)
    user.registrations.where(
      cancelled: false, 
      completed: false,
      status: ['Registered', 'Payment Pending', 'Payment Completed']
    ).where('start_date >= ? OR start_date IS NULL', Date.today).exists?
  end

  def get_current_url
    request.original_url
  end

  def canonical_url
    "#{request.protocol}#{request.host_with_port}#{request.path}"
  end

  def dev_images(image_name)
    # Always use CloudFront for these images since they're not in app/assets/images
    "https://d1w11gv0j27jrz.cloudfront.net/#{image_name}"
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
 
  

  def formatted_created_at_date(date)
    date = DateTime.parse(date)
    date_ist = date.in_time_zone('Asia/Kolkata')
    date_ist.strftime('%-dth %B, %Y %H:%M %p IST')
  end

  def formatted_date_with_year(date)
    return 'Not set' if date.blank?
    
    date = date.is_a?(String) ? DateTime.parse(date) : date
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
      set_meta_tags(title: title)
      content_for(:title) { title }
    else
      content_for?(:title) ? content_for(:title) : generate_title_from_url
    end
  end

  def set_page_meta(title:, description: nil, image: nil)
    tags = { title: title }
    tags[:description] = description if description.present?
    if image.present?
      tags[:og] = { image: image }
      tags[:twitter] = { image: image }
    end
    set_meta_tags(tags)
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

  def ga_conversion_tag
    return unless flash[:ga_event].present?

    ga_conversion_event(flash[:ga_event])
  end

  def ga_conversion_event(event)
    event = event.with_indifferent_access

    tag.div(
      hidden: true,
      data: {
        controller: "analytics",
        analytics_auto_value: true,
        analytics_event_name_value: event[:name],
        analytics_params_value: event[:params] || {}
      }
    )
  end


  def has_profile?(user)
    user&.user_profile.present?
  end

  




  def display_country_name(country_input)
    return 'No country specified' if country_input.blank?

    # Check if the input is a country code
    country = Carmen::Country.coded(country_input)
    if country
      country.name
    else
      # If it's not a code, assume it's already the country name
      country_input
    end
  end

  def registration_end_date(registration, package)
    registration.start_date + package.duration.to_i
  end
  
  

 

  

 
  
  

  
end
