class SearchArtistTool < RubyLLM::Tool
  description "Searches artist by name."
  param :artist_name, desc: "The name the artist"

  def execute(artist_name:)
    artist = Artist.find_by(name: artist_name)
    artist.nil? ? "No artist found for '#{artist_name}'" : artist
  end
end
