require "net/http"

class YoutubeService
  BASE_URL = "https://youtube.googleapis.com/youtube/v3/videos"
  API_KEY = Rails.application.credentials.google_api_key

  def initialize(link)
    query = { part: "snippet", id: get_youtube_id(link), key: API_KEY, prettyPrint: true }
    @uri = URI(BASE_URL)
    @uri.query = URI.encode_www_form(query)
  end

  def get_video
    res = Net::HTTP.get_response(@uri)
    if res.is_a?(Net::HTTPSuccess)
      @data = parse_data(res.body)
      get_detail
    end
  end

  private

  def get_youtube_id(url)
    url = url.gsub(/(>|<)/i, "").split(%r{(vi/|v=|/v/|youtu\.be/|/embed/)})
    return url if url[2].nil?

    id = url[2].split(/[^0-9a-z_\-]/i)
    id[0]
  end

  def parse_data(data)
    JSON.parse(data)
  end

  def get_detail
    id = @data["items"][0]["id"]
    item = @data["items"][0]["snippet"]
    {
      id: id,
      title: item["title"],
      description: item["description"],
      tags: item["tags"],
    }
  end
end
