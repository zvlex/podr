class FetchPodcast
  include ActiveModel::Validations

  def initialize(podcast_params, current_user)
    @user = current_user
    @podcast = Podcast.new do |pod|
      pod.category_id = podcast_params[:category_id]
      pod.url = podcast_params[:url]
    end
  end


  def determine_type(raw_page)
    Feedjira::Feed.determine_feed_parser_for_xml(raw_page)
  end

  def fetch_raw(podcast_url)
    Feedjira::Feed.fetch_raw(podcast_url)
  end

  def response_uri(host)
    Net::HTTP.get_response(URI(host)) rescue nil
  end

  def full_hyperlink(host)
    uri = URI(host)
    "http://#{uri.host}#{uri.path}?#{uri.query}"
  end

  def able_to_parse?(raw)
    Feedjira::Parser::ITunesRSS.able_to_parse?(raw)
  end

  def fetch_podcast_info
    if @podcast.valid?
      response = response_uri(@podcast.url)
      if response.nil?
        @podcast.errors.add(:url, 'unknown host')
        return @podcast
      else
        raw = fetch_raw(@podcast.url)
        feed_type = determine_type(raw)

        if feed_type
          if able_to_parse?(raw)
            feed = feed_type.parse(raw)
            create_podcast(feed, feed_type: feed_type, raw: raw, link: @podcast.url)
          else
            @podcast.errors.add(:url, 'not able to parse, not podcast')
            return @podcast
          end
        else
          hyperlink = search_rss_hyperlink(raw)
          if hyperlink
            feed_rss_link = full_hyperlink(hyperlink)
            response = response_uri(feed_rss_link)
          else
            @podcast.errors.add(:url, 'not able to parse, not podcast')
            return @podcast
          end

          if response.nil?
            @podcast.errors.add(:url, 'wrong rss link')
            return @podcast
          else
            raw_page = fetch_raw(feed_rss_link)
            if able_to_parse?(raw_page)
              feed_type = determine_type(raw_page)
              feed = feed_type.parse(raw_page)
              create_podcast(feed, feed_type: feed_type, raw: raw_page, link: feed_rss_link)
            else
              @podcast.errors.add(:url, 'not able to parse, not podcast')
              return @podcast
            end
          end
        end
      end
    else
      @podcast
    end
  end

  def create_podcast(feed, options={})
    feed_type = options[:feed_type].to_s.split('::').last
    nokogiri_raw = Nokogiri(options[:raw])

    if feed_type == 'ITunesRSS'
      itunes_image = nokogiri_raw.xpath('//image//url').children.to_s

      Podcast.where(atom_link: options[:link], user_id: @user.id).first_or_create(
        :title         => feed.title,
        :sub_title     => feed.itunes_summary,
        :url           => feed.url,
        :itunes_image  => itunes_image,
        :description   => feed.description,
        :author        => feed.itunes_author,
        :atom_link     => options[:link],
        :keywords      => feed.itunes_keywords,
        :user_id       => @user.id,
        :category_id   => @podcast.category_id
      )
    elsif feed_type == 'RSSFeedBurner'
      image = nokogiri_raw.xpath('//media:thumbnail').attribute('url').value
      keywords = nokogiri_raw.xpath('//media:keywords').children.to_s
      description = if feed.description.nil?
        nokogiri_raw.xpath('//itunes:subtitle').first.children.to_s
      else
        feed.description
      end

      Podcast.where(atom_link: options[:link], user_id: @user.id).first_or_create(
        :title         => feed.title,
        :sub_title     => description,
        :url           => feed.url,
        :itunes_image  => image,
        :description   => feed.description,
        :atom_link     => options[:link],
        :keywords      => keywords,
        :user_id       => @user.id,
        :category_id   => @podcast.category_id
      )
    end
  end

  # не совсем правильно определяет ссылки подкастов
  def search_rss_hyperlink(html_output)
    page = Nokogiri::HTML(html_output)

    link = ->(page, tag, tag_attr, value, options={}) do
      list = page.xpath("//#{tag}[contains(@#{tag_attr}, '#{value}')]")
      list.attribute('href').value.sub('www.', '') unless list.empty?
    end

    rss_value  = link.call(page, "link", "type", "application/rss+xml")
    atom_value = link.call(page, "link", "type", "application/atom+xml")
    href_value = link.call(page, "a", "class", "rss")
    rss_value || atom_value || href_value
  end
end