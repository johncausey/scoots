module Decision
  # wikipedia data grab example
  def wiki_get(url)
    begin
      data = Nokogiri::HTML(open(url))
      title = data.at_css('#firstHeading').text.strip if data.at_css('#firstHeading').text.strip
      pgraph = data.search('p').map(&:text) if data.search('p')
      leader = pgraph.first if pgraph
      pcount = pgraph.count.to_s if pgraph
      say_to_chan("\2Wikipedia Page - #{title}\2 - (#{pcount} paragraphs) - #{leader[0..150] + "..."}")
    rescue
      tell_chan_title(url)
    end
  end

  # github data grab example
  def git_get(url)
    begin
      title = Mechanize.new.get(url).title
      data = Nokogiri::HTML(open(url))
      repodesc = data.at_css('#repository_description.repository-description').text.strip if data.at_css('#repository_description.repository-description').text.strip
      last_commit = data.at_css('.author-name').text.strip if data.at_css('.author-name').text.strip
      say_to_chan("\2#{title}\2 - Last commit by #{last_commit} - #{repodesc[0..150]}")
    rescue
      tell_chan_title(url)
    end
  end

  # youtube data grab example
  def tube_get(url)
    begin
      data = Nokogiri::HTML(open(url))
      title = data.at_css('#eow-title').text.strip if data.at_css('#eow-title').text.strip
      views = data.at_css('.watch-view-count').text.strip if data.at_css('.watch-view-count').text.strip
      likes = data.at_css('.likes-count').text.strip if data.at_css('.likes-count').text.strip
      dislikes = data.at_css('.dislikes-count').text.strip if data.at_css('.dislikes-count').text.strip
      say_to_chan("\2Youtube - #{title}\2 - #{views} views - likes up/down at #{likes}/#{dislikes}")
    rescue
      tell_chan_title(url)
    end
  end

  # stackoverflow data grab example
  def so_get(url)
    begin
      data = Nokogiri::HTML(open(url))
      title = data.at_css('#question-header').text.strip if data.at_css('#question-header').text.strip
      vote_alignment = data.search('.vote-count-post').map(&:text) if data.search('.vote-count-post')
      say_to_chan("\2stackoverflow - #{title}\2 - Vote Alginment = #{vote_alignment.join(", ")}")
    rescue
      tell_chan_title(url)
    end
  end


  # decision fork based on url content
  def decide(content)
    if is_a_link(content)
      link = @strippedlink
      case link.to_s
      when /https?:\/\/[a-z]+.wikipedia.org\/wiki\/[\S]+/
        wiki_get(link.to_s)
      when /https?:\/\/[a-z]*?.?github.com\/\S+/
        git_get(link.to_s)
      when /https?:\/\/[a-z]*?.?youtube.com\/\S+/
        tube_get(link.to_s)
      when /https?:\/\/[a-z]*.?stackoverflow.com\/[\S]*/
        so_get(link.to_s)
      else
        tell_chan_title(link)
      end
    end
  end

end
