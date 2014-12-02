class RemoveIndexFromFeedItems < ActiveRecord::Migration
  def change
    remove_index :feed_items, :entry_id
  end
end
