class CreateConnections < ActiveRecord::Migration[7.1]
  def change
    create_table :connections, id: :string do |t|
      t.string :event_id, null: false
      t.string :from_user_id, null: false
      t.string :to_user_id, null: false
      t.string :status, default: "pending"  # pending, accepted, declined
      t.timestamps
    end
    add_index :connections, [:event_id, :from_user_id, :to_user_id], unique: true
  end
end
