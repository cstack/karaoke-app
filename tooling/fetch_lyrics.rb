require_relative './spotify_adapter.rb'
require_relative './song_list.rb'

song_list_filepath = File.expand_path(File.join(File.dirname(__FILE__), '../data/songs.csv'))
song_list = SongList.new(song_list_filepath)
adapter = SpotifyAdapter.new(api_key: File.read('SPOTIFY_API_KEY'))
song_list.songs.each do |song|
  id = song.spotify_id
  lyrics_filepath = File.expand_path(File.join(File.dirname(__FILE__), "../data/#{id}.txt"))
  if !File.exist?(lyrics_filepath)
    lyric_lines = adapter.get_track_lyrics(id)
    File.write(lyrics_filepath, lyric_lines.join("\n"))
  end
end