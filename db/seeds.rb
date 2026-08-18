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
puts "Deleting Database...."
# Version.destroy_all
# Artist.destroy_all
# Song.destroy_all

file = File.open "app/assets/data/random_tracks_seed.json"
tracks = JSON.load file

puts "Creating New Database ....."

tracks.each do |track|
  newSong = Song.new(title: track["title"])
  newSong.save!
  puts "Song Created"

  newArtist = Artist.new(name: track["artist"])
  newArtist.save!
  puts "Artist Created"

  newVersion = Version.new(type: track["type"], year: track["year"])
  newVersion.song = newSong
  newVersion.artist = newArtist
  newVersion.save!
  puts "Version Created"
end
