class VishraamRegistrationMailer < ApplicationMailer

  require 'sendgrid-ruby'
  include SendGrid

  def vishraam_registration_email(vishraam_registration)
    @vishraam_registration = vishraam_registration
    from = Email.new(email: 'ArogyaM@arogyam.life')
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    to = Email.new(email: email_address)
    subject = 'New VishraM Registration'
    html_content = render_to_string(template: 'vishraam_registration_mailer/vishraam_registration_email')
    content = Content.new(type: 'text/html', value: html_content)
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end

  def vishraam_registration_cancel_email(vishraam_registration_data)
    @vishraam_registration_data = vishraam_registration_data
    from = Email.new(email: 'ArogyaM@arogyam.life')
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    to = Email.new(email: email_address)
    subject = 'VishraM Registration Cancelled'
    html_content = render_to_string(template: 'vishraam_registration_mailer/vishraam_registration_cancel_email')
    content = Content.new(type: 'text/html', value: html_content)
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end
end



