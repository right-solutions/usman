# This migration comes from usman (originally 20131108102728)
class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.string  :image
      t.integer :imageable_id
      t.string  :imageable_type
      t.timestamps
    end

    add_index(:images, [ :imageable_id, :imageable_type ])
  end
end