class ChangeImageAndEntryIdTypeInFeedItems < ActiveRecord::Migration
  def change
    change_column :feed_items, :entry_id, :string
    change_column :feed_items, :image, :text
  end
end
