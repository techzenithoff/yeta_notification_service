class Notification < ApplicationRecord

    # Include shared utils.
    include SharedUtils::Generate

    before_create :generate_uuid


    enum status: { pending: 0, sent: 1, failed: 2 }

    validates :event_id, presence: true, uniqueness: true
    #validates :tenant_id, presence: true
end
