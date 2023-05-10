class RegistrationMailer < ApplicationMailer
  require 'sendgrid-ruby'
  include SendGrid
  
  def registration_email(registration)
    @registration = registration
    from = Email.new(email: 'ArogyaM@arogyam.life')
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    to = Email.new(email: email_address)
    subject = 'New Batch Registration'
    html_content = render_to_string(template: 'registration_mailer/registration_email')
    content = Content.new(type: 'text/html', value: html_content)
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end

  def registration_cancel_email(registration_data)
    @registration_data = registration_data
    from = Email.new(email: 'ArogyaM@arogyam.life')
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    to = Email.new(email: email_address)
    subject = 'Batch Registration Cancelled'
    html_content = render_to_string(template: 'registration_mailer/registration_cancel_email')
    content = Content.new(type: 'text/html', value: html_content)
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end 

  def registration_user_email(registration)
    @registration = registration
    from = Email.new(email: 'ArogyaM@arogyam.life')
    email_address = Rails.env.production? ? @registration.user.email : "rshan.ali@gmail.com"
    to = Email.new(email: email_address)
    subject = 'You registered for a batch!'
    html_content = render_to_string(template: 'registration_mailer/registration_user_email')
    content = Content.new(type: 'text/html', value: html_content)
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end 

  def registration_cancel_user_email(registration)
    @registration = registration
    from = Email.new(email: 'ArogyaM@arogyam.life')
    email_address = Rails.env.production? ? @registration.user.email : "rshan.ali@gmail.com"
    to = Email.new(email: email_address)
    subject = 'Batch registration cancelled'
    html_content = render_to_string(template: 'registration_mailer/registration_cancel_user_email')
    content = Content.new(type: 'text/html', value: html_content)
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end 
end