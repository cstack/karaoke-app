require 'csv'
require 'byebug'

class SongList
  class Song
    class << self
      def from_row(row)
        new(
          title: row["title"],
          artist: row["artist"],
          number_of_singers: row["number_of_singers"].to_i,
          year: row["year"].to_i,
          popularity: row["popularity"].to_i,
          duration_ms: row["duration_ms"].to_i,
          image_url: row["image_url"],
        )
      end
    end

    attr_reader :title, :artist, :number_of_singers, :year, :popularity, :duration_ms, :image_url

    def initialize(title:, artist:, number_of_singers:, year:, popularity:, duration_ms:, image_url:)
      @title = title
      @artist = artist
      @number_of_singers = number_of_singers
      @year = year
      @popularity = popularity
      @duration_ms = duration_ms
      @image_url = image_url
    end

    def decade
      (@year / 10).to_i * 10
    end

    def duration_seconds
      if @duration_ms.nil?
        debugger
      end
      (@duration_ms / 1000).to_i
    end

    def duration_minutes
      (duration_seconds / 60).to_i
    end
  end

  def initialize(filepath)
    @filepath = filepath
    @songs = CSV.read(filepath, headers: true).map do |row|
      Song.from_row(row)
    end
  end

  def to_json
    @songs.map { |row| row.to_hash }.to_json
  end

  def replace_contents(songs)
    songs = []
    songs.each do |song|
      songs << [song[:title], song[:artist], song[:number_of_singers], song[:year], song[:popularity], song[:duration_ms], song[:image_url]]
    end

    CSV.open(@filepath, "wb") do |csv|
      csv << ["title", "artist", "number_of_singers", "year", "popularity", "duration_ms", "image_url"]
      songs.each do |row|
        csv << row
      end
    end
  end

  def songs
    @songs
  end
end