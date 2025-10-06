class WelcomeMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    
    mail(
      from: 'ArogyaM <admin@arogyam.life>',
      to: user.email,
      subject: 'Welcome to ArogyaM'
    )
  end
end
