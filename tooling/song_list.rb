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

      def from_json(json)
        new(
          title: json[:title],
          artist: json[:artist],
          number_of_singers: json[:number_of_singers].to_i,
          year: json[:year].to_i,
          popularity: json[:popularity].to_i,
          duration_ms: json[:duration_ms].to_i,
          image_url: json[:image_url],
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

    def to_csv_row
      [title, artist, number_of_singers, year, popularity, duration_ms, image_url]
    end

    def to_hash
      {
        title: title,
        artist: artist,
        number_of_singers: number_of_singers,
        year: year,
        popularity: popularity,
        duration_ms: duration_ms,
        image_url: image_url,
      }
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
    @songs.map { |song| song.to_hash }.to_json
  end

  def to_csv
    CSV.generate do |csv|
      csv << ["title", "artist", "number_of_singers", "year", "popularity", "duration_ms", "image_url"]
      @songs.sort_by(&:title).map do |song|
        csv << song.to_csv_row
      end
    end
  end

  def replace_contents(songs)
    @songs = songs.map do |song|
      Song.from_json(song)
    end
    File.write(@filepath, to_csv)
  end

  def songs
    @songs
  end
end