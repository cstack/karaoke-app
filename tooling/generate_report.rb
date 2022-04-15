require_relative './song_list.rb'

filepath = File.expand_path(File.join(File.dirname(__FILE__), '../data/songs.csv'))
song_list = SongList.new(filepath)

