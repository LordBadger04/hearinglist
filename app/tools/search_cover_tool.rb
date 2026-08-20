require "json"
require "net/http"
require "uri"

API_KEY = "AIzaSyBZQcZK5FS5YQTcGeYMdeeBlqxNAaEJXhs"

class SearchCoverTool < RubyLLM::Tool
  description "Searches song cover by title."
  param :song_title, desc: "The keyword to search for"

  attr_reader :results

  def initialize
    @results = []
  end

  def execute(song_title:)
    found = get_video_info(song_title) || []
    @results.concat(found)
    found
  end

  def get_video_info(title)
    requete_recherche = "#{title} Cover"
    p requete_recherche
    # CORRECTION ICI : L"URL complète attendue par l"API Google
    base_url = "https://www.googleapis.com/youtube/v3/search"

    uri = URI(base_url)
    uri.query = URI.encode_www_form({
      part: "snippet",
      q: requete_recherche,
      type: "video",
      videoCategoryId: "10",
      maxResults: 2,
      key: API_KEY,
      order: "relevance"
    })

    begin
      response = Net::HTTP.get_response(uri)

      if response.code == "200"
        data = JSON.parse(response.body)
        items = data["items"]
        suggestions = []
        if items && !items.empty?
          # Extraction de l"identifiant unique de la vidéo
          items.each do |item|
            video_id = item["id"]["videoId"]
            video_url = "https://www.youtube.com/watch?v=#{video_id}"
            title = item["snippet"]["title"]
            photo_url = item["snippet"]["thumbnails"]["default"]["url"]
            suggestions << { video_url: video_url, title: title, photo_url: photo_url }
          end
          return suggestions
          #return items
        end
      else
        # Si l"API renvoie autre chose que 200, on affiche le corps de l"erreur pour débugger
        puts "Erreur API (#{response.code}) pour #{title} : #{response.body}"
      end
      nil
    rescue => e
      puts "Erreur réseau lors de la requête pour #{title} : #{e.message}"
      nil
    end
  end
end
