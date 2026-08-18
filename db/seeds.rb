# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "json"
require 'net/http'
require 'uri'

API_KEY = 'AIzaSyBZQcZK5FS5YQTcGeYMdeeBlqxNAaEJXhs'

# Method de generation de l'url
def get_url(artiste, titre, year)
  mots_cles_style = case style.to_s.downcase
  when 'studio'
    "album version"
  when 'live'
    "Live Performance"
  when 'acoustic'
    "Acoustic"
  else
    ""
  end
requete_recherche = "#{artiste} #{titre} #{mots_cles_style} -tutorial -lyrics -karaoke"
  # CORRECTION ICI : L'URL complète attendue par l'API Google
  base_url = "https://www.googleapis.com/youtube/v3/search"

  uri = URI(base_url)
  uri.query = URI.encode_www_form({
    part: 'snippet',
    q: requete_recherche,
    type: 'video',
    videoCategoryId: '10',
    maxResults: 1,
    key: API_KEY
  })

  begin
    response = Net::HTTP.get_response(uri)

    if response.code == "200"
      data = JSON.parse(response.body)
      items = data['items']

      if items && !items.empty?
        # Extraction de l'identifiant unique de la vidéo
        video_id = items.first['id']['videoId']
        return "https://www.youtube.com/watch?v=#{video_id}"
      end
    else
      # Si l'API renvoie autre chose que 200, on affiche le corps de l'erreur pour débugger
      puts "Erreur API (#{response.code}) pour #{titre} : #{response.body}"
    end
    nil
  rescue => e
    puts "Erreur réseau lors de la requête pour #{titre} : #{e.message}"
    nil
  end
end

puts "Deleting Database...."
Version.destroy_all
Artist.destroy_all
Song.destroy_all

file = File.open "app/assets/data/random_tracks_seed copy.json.json"
tracks = JSON.load file

puts "Creating New Database ....."

tracks.each do |track|
  title = track["title"]
  name = track["artist"]

  # On determine si la song est deja repertoriée
  if Song.find_by(title: title) == nil
    newSong = Song.new(title: title)
    newSong.save!
    puts "Song Created"
  else
    newSong = Song.find_by(title: title)
  end

  # On determine si l'artist est deja repertoriée
  if Artist.find_by(name: name) == nil
    newArtist = Artist.new(name: name)
    newArtist.save!
    puts "Artist Created"
  else
    newArtist = Artist.find_by(name: name)
  end

  # On genere le lien youtube de la version
  newLink = get_url(name, title, track["year"])

  newVersion = Version.new(style: track["type"], year: track["year"], version_url: newLink)
  newVersion.song = newSong
  newVersion.artist = newArtist
  newVersion.save!
  puts "Version Created"
end

puts "Finished database Seed"
