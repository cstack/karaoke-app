require_relative '../tooling/spotify_adapter.rb'
require 'csv'

PLAYLIST_ID = '3uXsjGstITnMQEjZziy6Bf'
adapter = SpotifyAdapter.new(api_key: File.read('SPOTIFY_API_KEY'))
songs = adapter.get_playlist_tracks(PLAYLIST_ID)


rows = []
songs.each do |song|
  rows << [song[:title], song[:artist], song[:number_of_singers], song[:year], song[:popularity], song[:duration_ms], song[:image_url]]
end

CSV.open(File.join(File.dirname(__FILE__), './songs.csv'), "wb") do |csv|
  csv << ["title", "artist", "number_of_singers", "year", "popularity", "duration_ms", "image_url"]
  rows.each do |row|
    csv << row
  end
end