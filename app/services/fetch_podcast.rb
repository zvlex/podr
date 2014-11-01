class FetchPodcast
  def initialize(podcast_params, current_user)
    @user = current_user
    @podcast = Podcast.new do |pod|
      pod.category_id = podcast_params[:category_id]
      pod.url = podcast_params[:url]
    end
  end

  def fetch_podcast_info
    if @podcast.valid?
      # Feedjira::Feed.fetch_and_parse.class
      raw_page = Feedjira::Feed.fetch_raw(@podcast.url)
      if Nokogiri(raw_page).xml?
        feed = Feedjira::Parser::ITunesRSS.parse(raw_page)
        create_podcast(feed, @podcast.url)
      else
        parsed_link = parse_page(raw_page)
        feed = parse_feed(parsed_link)
        create_podcast(feed, parsed_link)
      end
    else
      @podcast
    end
  end

  def create_podcast(feed, link)
    # raise feed.inspect
    Podcast.where(atom_link: link, user_id: @user.id).first_or_create(
      :title         => feed.title,
      :sub_title     => feed.itunes_summary,
      :url           => feed.url,
      :itunes_image  => feed.itunes_image,
      :description   => feed.description,
      :author        => feed.itunes_author,
      :atom_link     => link,
      :keywords      => feed.itunes_keywords,
      :user_id       => @user.id,
      :category_id   => @podcast.category_id
    )
  end

  def parse_feed(link)
    uri = URI.parse(link)
    full_url = "http://#{uri.host}#{uri.path}?#{uri.query}"
    fetch_xml = Feedjira::Feed.fetch_raw(full_url)
    Feedjira::Parser::ITunesRSS.parse(fetch_xml)
  end


  def parse_page(html_output)
    page = Nokogiri::HTML(html_output)

    link = ->(page, tag, tag_attr, value) do
      list = page.xpath("//#{tag}[contains(@#{tag_attr}, '#{value}')]")
      list.attribute('href').value.sub('www.', '') unless list.empty?
    end

    href_value = link.call(page, "a", "class", "rss")
    atom_value = link.call(page, "link", "type", "application/atom+xml")
    rss_value  = link.call(page, "link", "type", "application/rss+xml")

    href_value || atom_value || rss_value
  end
end