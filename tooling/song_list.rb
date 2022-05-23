require 'csv'
require 'byebug'

class SongList
  class Song
    class << self
      def from_row(row)
        spotify_id = row["spotify_id"]
        lyrics = lyrics_for_spotify_id(spotify_id)
        new(
          spotify_id: spotify_id,
          title: row["title"],
          artist: row["artist"],
          year: row["year"].to_i,
          popularity: row["popularity"].to_i,
          duration_ms: row["duration_ms"].to_i,
          image_url: row["image_url"],
          lyrics: lyrics,
        )
      end

      def lyrics_for_spotify_id(spotify_id)
        filepath = File.expand_path(File.join(File.dirname(__FILE__), "../data/#{spotify_id}.txt"))
        if File.exist?(filepath)
          File.read(filepath)
        else
          nil
        end
      end

      def from_hash(hash)
        spotify_id = hash[:spotify_id]
        lyrics = lyrics_for_spotify_id(spotify_id)
        new(
          spotify_id: spotify_id,
          title: hash[:title],
          artist: hash[:artist],
          year: hash[:year].to_i,
          popularity: hash[:popularity].to_i,
          duration_ms: hash[:duration_ms].to_i,
          image_url: hash[:image_url],
          lyrics: lyrics,
        )
      end
    end

    attr_reader :spotify_id, :title, :artist, :year, :popularity, :duration_ms, :image_url, :lyrics

    def initialize(spotify_id:, title:, artist:, year:, popularity:, duration_ms:, image_url:, lyrics:)
      @spotify_id = spotify_id
      @title = title
      @artist = artist
      @year = year
      @popularity = popularity
      @duration_ms = duration_ms
      @image_url = image_url
      @lyrics = lyrics
    end

    def to_csv_row
      [spotify_id, title, artist, year, popularity, duration_ms, image_url]
    end

    def to_hash
      {
        title: title,
        artist: artist,
        year: year,
        popularity: popularity,
        duration_ms: duration_ms,
        image_url: image_url,
        lyrics: lyrics,
      }
    end

    def sort_key
      [title, year]
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
      csv << ["spotify_id", "title", "artist", "year", "popularity", "duration_ms", "image_url"]
      @songs.sort_by(&:sort_key).map do |song|
        csv << song.to_csv_row
      end
    end
  end

  def replace_contents(songs)
    @songs = songs.map do |song|
      Song.from_hash(song)
    end
    File.write(@filepath, to_csv)
  end

  def songs
    @songs
  end
end