class OnlineConsultationMailer < ApplicationMailer
  require 'sendgrid-ruby'
  include SendGrid

  def online_consultation_email(online_consultation)
    @online_consultation = online_consultation
    from = Email.new(email: 'OnlineConsultation@arogyam.life')
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    to = Email.new(email: email_address)
    subject = 'Online Consultation Booked(unconfirmed)'
    html_content = render_to_string(template: 'online_consultation_mailer/online_consultation_email')
    content = Content.new(type: 'text/html', value: html_content)
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end

  def online_consultation_confirmation_email(online_consultation)
    @online_consultation = online_consultation
    from = Email.new(email: 'OnlineConsultation@arogyam.life')
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    to = Email.new(email: email_address)
    subject = 'Online Consultation Booked(confirmed)'
    html_content = render_to_string(template: 'online_consultation_mailer/online_consultation_confirmation_email')
    content = Content.new(type: 'text/html', value: html_content)
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end

  def online_consultation_cancellation_email(online_consultation)
    @online_consultation = online_consultation
    from = Email.new(email: 'OnlineConsultation@arogyam.life')
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    to = Email.new(email: email_address)
    subject = 'Online Consultation Cancelled'
    html_content = render_to_string(template: 'online_consultation_mailer/online_consultation_cancellation_email')
    content = Content.new(type: 'text/html', value: html_content)
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end


  def online_consultation_user_confirmation_email(online_consultation)
    @online_consultation = online_consultation
    @user =  @online_consultation.user
    from = Email.new(email: 'OnlineConsultation@arogyam.life')
    email_address = Rails.env.production? ? "#{@user.email}" : "rshan.ali@gmail.com"
    to = Email.new(email: email_address)
    subject = 'Your Consultation is Confirmed!'
    html_content = render_to_string(template: 'online_consultation_mailer/online_consultation_user_confirmation_email')
    content = Content.new(type: 'text/html', value: html_content)
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end

  def online_consultation_user_cancellation_email(online_consultation)
    @online_consultation = online_consultation
    @user =  @online_consultation.user
    from = Email.new(email: 'OnlineConsultation@arogyam.life')
    email_address = Rails.env.production? ? "#{@user.email}" : "rshan.ali@gmail.com"
    to = Email.new(email: email_address)
    subject = 'Your Consultation is Cancelled!'
    html_content = render_to_string(template: 'online_consultation_mailer/online_consultation_user_cancellation_email')
    content = Content.new(type: 'text/html', value: html_content)
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end

end