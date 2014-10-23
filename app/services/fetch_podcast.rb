class FetchPodcast
  def initialize(params)
    @params = params
    @podcast = Podcast.new do |pod|
      pod.category_id = params[:category_id]
      pod.url = params[:url]
    end
  end

  def fetch_podcast_info
    if @podcast.valid?
      xml = Feedjira::Feed.fetch_raw(@params[:url])
      if Nokogiri::XML(xml).errors.empty?
        feed = Feedjira::Parser::ITunesRSS.parse(xml)
        create_podcast(feed, @params[:url])
      else
        url = get_atom_link(xml)
        feed = parse_feed(url)
        create_podcast(feed, url)
      end
    else
      @podcast
    end
  end

  def create_podcast(feed, link)
    Podcast.where(atom_link: link).first_or_create(
      :title         => feed.title,
      :sub_title     => feed.itunes_summary,
      :url           => feed.url,
      :itunes_image  => feed.itunes_image,
      :description   => feed.description,
      :author        => feed.itunes_author,
      :owners_email  => feed.itunes_owners[0].email,
      :atom_link     => link,
      :keywords      => feed.itunes_keywords,
      :category_id   => @params[:category_id]
    )
  end

  def parse_feed(get_url)
    uri = URI.parse(get_url)
    full_url = "http://#{uri.host}#{uri.path}#{uri.query}"
    xml = Feedjira::Feed.fetch_raw(full_url)
    Feedjira::Parser::ITunesRSS.parse(xml)
  end

  def get_atom_link(xml)
    page = Nokogiri::HTML(xml)
    %w(atom+xml rss+xml).each do |type|
      list = page.xpath("//link[contains(@type, 'application/" + type +"')]")
      return list.attribute('href').value unless list.empty?
    end
  end
end