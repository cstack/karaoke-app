require 'csv'
require 'byebug'

class SongList
  def initialize(filepath)
    @filepath = filepath
    @rows = CSV.read(filepath, headers: true)
  end

  def to_json
    @rows.map { |row| row.to_hash }.to_json
  end

  def replace_contents(songs)
    rows = []
    songs.each do |song|
      rows << [song[:title], song[:artist], song[:number_of_singers], song[:year], song[:popularity], song[:duration_ms], song[:image_url]]
    end

    CSV.open(@filepath, "wb") do |csv|
      csv << ["title", "artist", "number_of_singers", "year", "popularity", "duration_ms", "image_url"]
      rows.each do |row|
        csv << row
      end
    end
  end
end