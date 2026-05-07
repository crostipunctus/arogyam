# Preview at http://localhost:3000/rails/mailers/welcome_mailer
class WelcomeMailerPreview < ActionMailer::Preview
  def welcome_email
    user = User.new(first_name: "Anjali", email: "anjali@example.com")
    WelcomeMailer.welcome_email(user)
  end
end
