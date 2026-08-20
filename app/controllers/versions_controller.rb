class VersionsController < ApplicationController
  def new
    @version = Version.new
    # Optionnel : d'ou vient l'utilisateur, pour le renvoyer a sa liste apres coup.
    @list = List.find_by(id: params[:list_id])
  end

  def create
    @version = Version.new(version_params)
    @list = List.find_by(id: params[:list_id])

    # Un seul formulaire, mais trois enregistrements : Song, Artist, puis la
    # Version qui relie les deux. On reutilise la Song / l'Artist s'ils existent
    # deja, sinon leur validation d'unicite ferait echouer la creation.
    song = Song.find_or_initialize_by(title: @version.song_title.to_s.strip)
    artist = Artist.find_or_initialize_by(name: @version.artist_name.to_s.strip)
    @version.song = song
    @version.artist = artist

    if save_all(song, artist)
      redirect_to after_create_path, notice: "Version added to the catalog."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Les trois enregistrements vont ensemble : si l'un echoue, on annule tout
  # pour ne pas laisser une Song ou un Artist orphelin en base.
  def save_all(song, artist)
    Version.transaction do
      song.save!
      artist.save!
      @version.save!
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    copy_errors_to_version(e.record)
    false
  end

  # simple_form n'affiche que les erreurs portees par @version. On y recopie
  # donc celles de la Song ou de l'Artist sur le champ correspondant.
  def copy_errors_to_version(record)
    return if record == @version

    field = record.is_a?(Song) ? :song_title : :artist_name
    record.errors.each { |error| @version.errors.add(field, error.message) }
  end

  def after_create_path
    @list ? new_list_bookmark_path(@list) : root_path
  end

  def version_params
    params.require(:version).permit(:song_title, :artist_name, :year, :style, :version_url)
  end
end
