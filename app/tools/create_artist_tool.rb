class CreateArtistTool < RubyLLM::Tool
  description "Creates a artist for the current user."
  param :artist_name, desc: "The name of the artist"

  def execute(artist_name:)
    if Artist.find_by(name: artist_name).nil?
      Artist.create!(name: artist_name)
      { name: artist_name }
    else
      "#{artist_name} est deja dans la bibliotheque"
    end

  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end
end
