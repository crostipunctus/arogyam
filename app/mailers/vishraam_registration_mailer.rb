class VishraamRegistrationMailer < ApplicationMailer
  def vishraam_registration_email(vishraam_registration)
    @vishraam_registration = vishraam_registration
    email_address = Rails.env.production? ? ["admin@arogyam.life", "wellnesscenter@satsang-foundation.org"] : "rshan.ali@gmail.com"
    
    mail(
      from: 'ArogyaM <admin@arogyam.life>',
      to: email_address,
      subject: 'New VishraM Registration'
    )
  end

  def vishraam_registration_cancel_email(vishraam_registration_data)
    @vishraam_registration_data = vishraam_registration_data
    email_address = Rails.env.production? ? ["admin@arogyam.life", "wellnesscenter@satsang-foundation.org"] : "rshan.ali@gmail.com"
    
    mail(
      from: 'ArogyaM <admin@arogyam.life>',
      to: email_address,
      subject: 'VishraM Registration Cancelled'
    )
  end

  def vishraam_registration_user_confirmation_email(vishraam_registration)
    @vishraam_registration = vishraam_registration
    email_address = Rails.env.production? ? @vishraam_registration.user.email : "rshan.ali@gmail.com"
    
    mail(
      from: 'ArogyaM <admin@arogyam.life>',
      reply_to: ['admin@arogyam.life', 'wellnesscenter@satsang-foundation.org'],
      to: email_address,
      subject: 'VishraM Registration Confirmation'
    )
  end

  def vishraam_registration_user_cancellation_email(vishraam_registration)
    @vishraam_registration = vishraam_registration
    email_address = Rails.env.production? ? @vishraam_registration.user.email : "rshan.ali@gmail.com"
    
    mail(
      from: 'ArogyaM <admin@arogyam.life>',
      reply_to: ['admin@arogyam.life', 'wellnesscenter@satsang-foundation.org'],
      to: email_address,
      subject: 'VishraM Registration Cancellation'
    )
  end
end
