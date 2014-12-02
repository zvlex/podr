module PodcastsHelper
  def published_at(obj)
    obj.feed_items.order('published_at ASC').last.published_at
  end

  def count_unread(obj)
    obj.feed_items.where(listened: false).count
  end
end
