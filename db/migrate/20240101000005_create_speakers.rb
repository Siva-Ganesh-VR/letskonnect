class CreateSpeakers < ActiveRecord::Migration[7.1]
  def change
    create_table :speakers, id: :string do |t|
      t.string :event_id, null: false
      t.string :name, null: false
      t.string :title, default: ""
      t.string :company, default: ""
      t.timestamps
    end
    add_index :speakers, :event_id
  end
end
