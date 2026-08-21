class SearchSongTool < RubyLLM::Tool
  description "Searches song by title."
  param :song_title, desc: "The title the song"

  def execute(song_title:)
    song = Song.find_by(title: song_title)
    song.nil? ? "No song found for '#{song_title}'" : song
  end
end
