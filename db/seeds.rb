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
Version.destroy_all
Artist.destroy_all
Song.destroy_all

file = File.open "app/assets/data/random_tracks_seed.json"
tracks = JSON.load file

puts "Creating New Database ....."

tracks.each do |track|

  title = track["title"]
  name = track["artist"]
  if Song.find_by(title: title) == nil
    newSong = Song.new(title: title)
    newSong.save!
    puts "Song Created"
  else
    newSong = Song.find_by(title: title)
  end

  if Artist.find_by(name: name) == nil
    newArtist = Artist.new(name: name)
    newArtist.save!
    puts "Artist Created"
  else
    newArtist = Artist.find_by(name: name)
  end

  newVersion = Version.new(style: track["type"], year: track["year"])
  newVersion.song = newSong
  newVersion.artist = newArtist
  newVersion.save!
  puts "Version Created"
end

puts "Finished database Seed"
