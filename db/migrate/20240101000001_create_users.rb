class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :string do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role, null: false, default: "attendee"
      t.string :title, default: ""
      t.string :company, default: ""
      t.text   :interests, default: ""
      t.string :avatar_initials, default: ""
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :role
  end
end
