class CreateSupportTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :support_tickets, id: :string do |t|
      t.string :tenant_id
      t.string :submitted_by
      t.string :subject, null: false
      t.text   :body, default: ""
      t.string :priority, default: "normal"  # normal, high, urgent
      t.string :status, default: "open"      # open, in_progress, resolved
      t.timestamps
    end
    add_index :support_tickets, :status
    add_index :support_tickets, :priority
  end
end
