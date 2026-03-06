class Accounts::PurgeDeletedAccountsJob < ApplicationJob
  queue_as :default

  def perform
    Account.pending_deletion.where("destroy_after <= ?", Time.current).find_each do |account|
      account.destroy!  # supprime aussi le profil polymorphique (User / Customer)
    end
  end
end
