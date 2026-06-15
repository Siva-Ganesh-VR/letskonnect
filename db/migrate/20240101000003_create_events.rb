class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events, id: :string do |t|
      t.string :organizer_id, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.string :event_type, default: "Conference"
      t.string :tagline, default: ""
      t.text   :description, default: ""
      t.string :location, default: ""
      t.string :start_date, null: false
      t.string :end_date, null: false
      t.string :status, default: "draft"   # draft, published, archived
      t.string :hero_image, default: ""
      t.integer :capacity, default: 0
      t.timestamps
    end
    add_index :events, :slug, unique: true
    add_index :events, :organizer_id
    add_index :events, :status
  end
end
