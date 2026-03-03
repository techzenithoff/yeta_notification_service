# app/mailers/notification_mailer.rb
class NotificationMailer < ApplicationMailer
  #default from: 'noreply@tonapp.com'

    default from: "YETA+ <#{ENV["#{Rails.env.upcase}_EMAIL_USERNAME"]}>"
  # 🔹 OTP dynamique
  def send_otp(recipient, subject)
    @data = params[:data]
    mail(to: recipient, subject: subject)
  end

  # 🔹 Email générique fallback
  def generic_email(recipient, subject, message)
    @message = message
    mail(to: recipient, subject: subject)
  end
end