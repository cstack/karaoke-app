require_relative './song_list.rb'
require 'json'

filepath = File.expand_path(File.join(File.dirname(__FILE__), '../data/songs.csv'))
song_list = SongList.new(filepath)
json_blob = song_list.to_json
File.write('src/songs.json', json_blob)