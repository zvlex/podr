module PodcastsHelper
  def published_at(obj)
    obj.feed_items.order('published_at ASC').last.published_at
  end

end
