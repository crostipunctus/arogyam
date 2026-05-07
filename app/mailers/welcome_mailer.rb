class WelcomeMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    
    mail(
      from: 'ArogyaM <admin@arogyam.life>',
      reply_to: ['admin@arogyam.life', 'wellnesscenter@satsang-foundation.org'],
      to: user.email,
      subject: 'Welcome to ArogyaM'
    )
  end
end
