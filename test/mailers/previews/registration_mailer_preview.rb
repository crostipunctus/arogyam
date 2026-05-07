# Preview at http://localhost:3000/rails/mailers/registration_mailer
class RegistrationMailerPreview < ActionMailer::Preview
  def registration_user_email
    RegistrationMailer.registration_user_email(sample_registration)
  end

  def registration_cancel_user_email
    RegistrationMailer.registration_cancel_user_email(sample_registration)
  end

  def registration_email
    RegistrationMailer.registration_email(sample_registration)
  end

  def registration_cancel_email
    RegistrationMailer.registration_cancel_email(
      email: "anjali@example.com",
      start_date: Date.today + 14.days
    )
  end

  private

  def sample_registration
    user = User.new(first_name: "Anjali", last_name: "Sharma", email: "anjali@example.com")
    package = Package.new(name: "Panchakarma", duration: "14", cost: "45,000")
    Registration.new(
      user: user,
      package: package,
      start_date: Date.today + 14.days,
      duration: "14"
    )
  end
end
