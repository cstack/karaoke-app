require_relative './song_list.rb'
require 'byebug'

def truncate(string, max)
  string.length > max ? "#{string[0...max]}..." : string
end

def histogram(values)
  values.group_by { |value| value }.map { |value, array| [value, array.count] }
end

def print_histogram_sorted_by_count(values)
  histogram(values).sort_by(&:last).each do |value, count|
    puts "#{value}: #{count}"
  end
end

def print_histogram_sorted_by_key(values)
  histogram(values).sort.each do |value, count|
    puts "#{value}: #{count}"
  end
end

filepath = File.expand_path(File.join(File.dirname(__FILE__), '../data/songs.csv'))
song_list = SongList.new(filepath)

puts "By Decade"
print_histogram_sorted_by_key(song_list.songs.map(&:decade))

puts "By Duration"
print_histogram_sorted_by_key(song_list.songs.map(&:duration_minutes))

puts "Least popular"
song_list.songs.sort_by(&:popularity).first(10).each do |song|
  puts "#{song.popularity} - #{song.title}"
end

puts "Most popular"
song_list.songs.sort_by(&:popularity).last(5).each do |song|
  puts "#{song.popularity} - #{song.title}"
end
