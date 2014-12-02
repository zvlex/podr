module ApplicationHelper
  def category_list
    current_user.categories
  end

  def podcast_list(category)
    current_user.podcasts.where(category_id: category)
  end

  def count_unread(obj)
    obj.feed_items.where(listened: false).count
  end
end
