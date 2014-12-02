class ChangeColumnTypeInFeedItems < ActiveRecord::Migration
  def change
    change_column :feed_items, :entry_id, :text
  end
end
