class CreateNotifications < ActiveRecord::Migration[6.1]
    def change
        create_table :notifications do |t|
            t.uuid :uuid, null: false
            t.string :event_id, null: false
            #t.string :tenant_id, null: false
            t.string :channel
            t.string :recipient
            t.integer :status, default: 0
            t.text :error
            t.timestamps
        end

        add_index :notifications, :event_id, unique: true
        add_index :notifications, :uuid, unique: true
        #add_index :notifications, :tenant_id
    end
end
