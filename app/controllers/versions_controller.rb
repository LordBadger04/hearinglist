class VersionsController < ApplicationController
  def new
    @version = Version.new
  end

  def create
    @version = Version.new(version_params)
    @version.song = find_or_create_song
    @version.artist = find_or_create_artist
    if @version.save
      redirect_to lists_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private


    def find_or_create_song
      title = params.dig(:version, :song).to_s.strip
      return nil if title.blank?
      Song.find_or_create_by(title: title)
    end

    def find_or_create_artist
      name = params.dig(:version, :artist).to_s.strip
      return nil if name.blank?
      Artist.find_or_create_by(name: name)
    end

  def version_params
    params.require(:version).permit(:style, :version_url, :year)
  end
end
