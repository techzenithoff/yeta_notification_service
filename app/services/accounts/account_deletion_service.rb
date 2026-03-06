
module Accounts
    class AccountDeletionService
        DEFAULT_DELAY = (ENV["ACCOUNT_DELETION_DELAY"]).to_i.days

        def initialize(account)
            @account = account
        end

        # Étape 1 : programmer la suppression
        def schedule_deletion!(delay = DEFAULT_DELAY)
            @account.update!(
            scheduled_for_deletion_at: Time.current + delay
            )

            send_confirmation_email

            # Lancer le worker pour ce compte précis
            AccountDeletionWorker.perform_in(delay, @account.id)
        end

        # Étape 2 : suppression définitive
        def delete_now!
            ActiveRecord::Base.transaction do
            # Supprime aussi le profil polymorphe
            @account.accountable&.destroy!

            @account.destroy!
            end
        end


         private

        def send_confirmation_email
            AccountMailer.deletion_scheduled(@account).deliver_later
        end


    end
end
