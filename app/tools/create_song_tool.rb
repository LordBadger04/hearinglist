class CreateSongTool < RubyLLM::Tool
  description "Creates a song for the current user."
  param :song_title, desc: "The simple title of the song"

  def execute(song_title:)
    if Song.find_by(title: song_title.downcase.capitalize).nil?
      Song.create!(title: song_title.downcase.capitalize)
      { title: song_title }
    else
      "#{song_title} est deja dans la bibliotheque"
    end

  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end
end
