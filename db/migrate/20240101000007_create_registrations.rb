class CreateRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :registrations, id: :string do |t|
      t.string   :event_id, null: false
      t.string   :user_id, null: false
      t.string   :ticket_tier_id, null: false
      t.string   :code, null: false
      t.datetime :checked_in_at
      t.timestamps
    end
    add_index :registrations, :code, unique: true
    add_index :registrations, [:event_id, :user_id], unique: true
    add_index :registrations, :event_id
    add_index :registrations, :user_id
  end
end
