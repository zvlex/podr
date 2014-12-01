class ParseEntries < FetchPodcast
  def initialize(link, podcast)
    @link = link
    @podcast = podcast
  end

  def entries
    raw = fetch_raw(@link)
    type = determine_type(raw)
    feed = type.parse(raw).entries
    create_feed_items(feed)
  end

  def create_feed_items(items)
    items.each do |item|
      image = if item.respond_to?(:image)
                item.image
              else
                item.enclosure_url                
              end
      # raise item.inspect  
      @podcast.feed_items.where(entry_id: item.entry_id).first_or_create do |i|
        i.title = item.title
        i.summary = item.summary
        i.url = item.url
        i.entry_id = item.entry_id
        i.image = image
        i.published_at = item.published
      end
    end
  end
end