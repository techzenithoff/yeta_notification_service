# app/mailers/notification_mailer.rb
class NotificationMailer < ApplicationMailer
  #default from: 'noreply@tonapp.com'

    default from: "YETA+ <#{ENV.fetch("#{Rails.env.upcase}_EMAIL_USERNAME") { Rails.application.credentials.dig(:email, :production, :user_name) }}>"
  
    
    # OTP dynamique
    def send_otp(recipient, subject)
        @data = params[:data]
        mail(to: recipient, subject: subject)
    end

    # Email générique fallback
    def generic_email(recipient, subject, message)
        @message = message
        mail(to: recipient, subject: subject)
    end

    



end