class CreateVersionTool < RubyLLM::Tool
  description "Creates a version with the song and artist for the current user but first you must add the artist and the song to our database"
  param :song_title, desc: "The title of the song"
  param :artist_name, desc: "The name of the artist"
  param :version_url, desc: "The youtube url of the version"
  param :version_style, desc: "The style of the version, it can be live, album or acoustic"


  def execute(song_title:, artist_name:, version_url:, version_style:)
    song = Song.find_by(title: song_title)
    artist = Artist.find_by(name: artist_name)
    Version.create!(
      song: song,
      artist: artist,
      version_url: version_url,
      style: version_style
    )

  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end
end
