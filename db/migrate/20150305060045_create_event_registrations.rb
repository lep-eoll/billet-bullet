class CreateEventRegistrations < ActiveRecord::Migration
  def up
    create_table :event_registrations do |t|
      t.string :name

      t.belongs_to :line_item
      t.timestamps null: false
    end
  end

  def down
    drop_table :event_registrations
  end
end
