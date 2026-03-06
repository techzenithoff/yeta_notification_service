# app/services/account_deletion_sweeper.rb
module Accounts
    class AccountDeletionSweeper
    def self.run
        Account.where("scheduled_for_deletion_at <= ?", Time.current).find_each do |account|
            Accounts::AccountDeletionService.new(account).delete_now!
        end
    end
    end
end
