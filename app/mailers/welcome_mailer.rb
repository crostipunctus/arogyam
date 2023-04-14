class WelcomeMailer < ApplicationMailer
  require 'sendgrid-ruby'
  include SendGrid

  def welcome_email(user)
    from = Email.new(email: 'ArogyaM@arogyam.life')
    to = Email.new(email: user.email)
    subject = 'Welcome to ArogyaM'
    content = Content.new(type: 'text/plain', value: 'Thank you for signing up! We hope you find our services useful. Please feel free to contact us at wellnesscenter@satsang-foundation.org')
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end


end
