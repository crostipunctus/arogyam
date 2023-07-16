class ContactMailer < ApplicationMailer
  require 'sendgrid-ruby'
  include SendGrid

  def contact_email(contact)
    @contact = contact
    from = Email.new(email: 'ContactForm@arogyam.life')
    email_address = Rails.env.production? ? "wellnesscenter@satsang-foundation.org" : "rshan.ali@gmail.com"
    to = Email.new(email: email_address)
    subject = 'Contact Form Enquiry'
    html_content = render_to_string(template: 'contact_mailer/contact_email')
    content = Content.new(type: 'text/html', value: html_content)
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end
end

