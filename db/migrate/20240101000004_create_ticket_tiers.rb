class CreateTicketTiers < ActiveRecord::Migration[7.1]
  def change
    create_table :ticket_tiers, id: :string do |t|
      t.string  :event_id, null: false
      t.string  :name, null: false
      t.integer :price_cents, default: 0
      t.integer :quantity, default: 100
      t.integer :sort_order, default: 0
      t.timestamps
    end
    add_index :ticket_tiers, :event_id
  end
end
