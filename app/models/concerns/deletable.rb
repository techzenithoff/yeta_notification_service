# frozen_string_literal: true
module Deletable
	extend ActiveSupport::Concern

    ## For instance methods and constatntes
	included do

        ## Constantes
       
        PASSCODE_WINDOW = 5.minutes   

    
	end

     # Génère un OTP de 6 chiffres
    def generate_delete_account_otp!
        update!(delete_account_token: SecureRandom.hex(30), delete_account_otp: rand(100000..999999).to_s, delete_account_otp_sent_at: Time.current)
  
    end

    # Vérifie la validité de l’OTP
    def delete_account_valid_otp?(code)
        return false if delete_account_otp.blank?
        return false if delete_account_otp_expired?

       
        delete_account_otp == code
    end

    # Expire au bout de 10 minutes
    def delete_account_otp_expired?

       
        delete_account_otp_sent_at < PASSCODE_WINDOW.ago
    end



    def confirm_deletion!(code)
        return false if code != self.delete_account_otp || delete_account_otp_expired?
        update!(delete_account_otp: nil, delete_account_otp_sent_at: nil, delete_account_token: nil)
    end

    

    # Vérifie si suppression programmée
  def scheduled_for_deletion?
    scheduled_for_deletion_at.present?
  end

  # Restaurer le compte
  def restore!
    update!(scheduled_for_deletion_at: nil)
  end


  # Devise callback : après connexion réussie
  def after_database_authentication
    if scheduled_for_deletion?
      restore!
      session[:restored_account] = true
      Rails.logger.info "Account #{id} restored automatically after login."
    end
  end


    
  

  

    
        


	class_methods do
	    # Add shared class methods here
	    # Example:
	    # def authenticate(email, password)
	    #   user = find_by(email: email)
	    #   user && user.authenticate(password)
	    # end

        
	end


    private

   

  

	
	   
end