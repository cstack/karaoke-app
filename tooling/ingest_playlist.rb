require_relative './spotify_adapter.rb'
require_relative './song_list.rb'

filepath = File.expand_path(File.join(File.dirname(__FILE__), '../data/songs.csv'))
song_list = SongList.new(filepath)
PLAYLIST_ID = '3uXsjGstITnMQEjZziy6Bf'
adapter = SpotifyAdapter.new(api_key: File.read('SPOTIFY_API_KEY'))
songs = adapter.get_playlist_tracks(PLAYLIST_ID)
song_list.replace_contents(songs)