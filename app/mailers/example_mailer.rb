class ExampleMailer < ApplicationMailer
  require 'sendgrid-ruby'
  include SendGrid

  def welcome_email
    from = Email.new(email: 'admin@arogyam.life')
    to = Email.new(email: "rshan.ali@gmail.com")
    subject = 'Welcome to ArogyaM'
    content = Content.new(type: 'text/plain', value: 'Thank you for signing up! We hope you find our services useful. Please feel free to contact us at arogyamtesting@gmail.com')
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    
  end


end
