class CreateEventSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :event_sessions, id: :string do |t|
      t.string :event_id, null: false
      t.string :speaker_id
      t.string :title, null: false
      t.string :track, default: "Main stage"
      t.string :kind, default: "Talk"
      t.string :starts_at, null: false
      t.string :ends_at, null: false
      t.string :room, default: ""
      t.timestamps
    end
    add_index :event_sessions, :event_id
  end
end
