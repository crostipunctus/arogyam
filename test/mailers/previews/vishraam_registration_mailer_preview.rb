# Preview at http://localhost:3000/rails/mailers/vishraam_registration_mailer
class VishraamRegistrationMailerPreview < ActionMailer::Preview
  def vishraam_registration_user_confirmation_email
    VishraamRegistrationMailer.vishraam_registration_user_confirmation_email(sample_vishraam)
  end

  def vishraam_registration_user_cancellation_email
    VishraamRegistrationMailer.vishraam_registration_user_cancellation_email(sample_vishraam)
  end

  def vishraam_registration_email
    VishraamRegistrationMailer.vishraam_registration_email(sample_vishraam)
  end

  def vishraam_registration_cancel_email
    VishraamRegistrationMailer.vishraam_registration_cancel_email(
      email: "anjali@example.com",
      date: Date.today + 7.days
    )
  end

  private

  def sample_vishraam
    user = User.new(first_name: "Anjali", last_name: "Sharma", email: "anjali@example.com")
    VishraamRegistration.new(
      user: user,
      date: Date.today + 7.days,
      duration: "7"
    )
  end
end
