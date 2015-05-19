class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.jsonb :payload, null: false, default: '{}'
      t.timestamps null: false
    end
    add_index :events, :payload, using: :gin
  end
end
