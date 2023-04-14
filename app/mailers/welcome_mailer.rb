class WelcomeMailer < ApplicationMailer
  require 'sendgrid-ruby'
  include SendGrid

  def welcome_email(user)
    @user = user
    from = Email.new(email: 'ArogyaM@arogyam.life')
    to = Email.new(email: user.email)
    subject = 'Welcome to ArogyaM'
    html_content = render_to_string(template: 'welcome_mailer/welcome_email')

    content = Content.new(type: 'text/html', value: html_content)
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end


end
