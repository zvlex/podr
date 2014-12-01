class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
      t.references :podcast, index: true
      t.string :title
      t.text :summary
      t.string :url
      t.string :entry_id
      t.string :image
      t.datetime :published_at
      t.boolean :listened, default: false

      t.timestamps
    end
    add_index :feed_items, :entry_id, unique: true
  end
end
