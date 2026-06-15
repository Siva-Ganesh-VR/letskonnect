class CreateTenants < ActiveRecord::Migration[7.1]
  def change
    create_table :tenants, id: :string do |t|
      t.string :name, null: false
      t.string :plan, default: "starter"  # starter, growth, enterprise
      t.string :status, default: "active" # active, suspended, churned
      t.integer :monthly_cents, default: 0
      t.string :billing_email, default: ""
      t.date   :joined_on
      t.timestamps
    end
  end
end
