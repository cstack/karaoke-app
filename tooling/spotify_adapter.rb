require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'byebug'

class SpotifyAdapter
  # https://rapidapi.com/Glavier/api/spotify23/

  class TooManyRequests < StandardError; end

  def initialize(api_key:)
    puts "Using api key #{api_key}"
    @api_key = api_key
  end

  def get_playlist_tracks(playlist_id)
    puts "Fetching playlist #{playlist_id}"
    items = make_paginated_request(path: "/playlist_tracks/", params: { id: playlist_id })
    puts "Fetched #{items.count} songs"
    items.map do |item|
      convert_track(item["track"])
    end
  end

  def make_paginated_request(path:, params: {})
    offset = 0
    limit = 100
    more = true
    requests_made = 0
    max_requests = 5 # prevent infinite loop
    items = []
    while more && requests_made < max_requests
      requests_made += 1
      puts "Requesting page #{requests_made}"
      json = with_backoff_retry do
        make_request(path: path, params: params.merge(offset: offset, limit: limit))
      end
      offset += limit
      more = json["next"]
      if json["items"].nil?
        debugger
      end
      items += json["items"]
    end
    if more
      raise "Did not reach last page after #{requests_made} requests. Possible infinite loop."
    end
    items
  end

  def with_backoff_retry
    seconds_to_wait = 0.25
    while true
      begin
        return yield
      rescue TooManyRequests
        sleep seconds_to_wait
        seconds_to_wait *= 2
      end
    end
  end

  def make_request(path:, params: {})
    host = "spotify23.p.rapidapi.com"
    params = {
      offset: 0,
      limit: 100,
    }.merge(params)
    url = URI::HTTPS.build(host: host, path: path, query: URI.encode_www_form(params))

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Host"] = 'spotify23.p.rapidapi.com'
    request["X-RapidAPI-Key"] = @api_key

    response = http.request(request)
    case response.code
    when "200"
      body = response.read_body
      JSON.parse(body)
    when "429"
      raise TooManyRequests
    else
      raise "Unexpected http code #{response.code}"
    end
  end

  def convert_track(track)
    {
      title: track["name"],
      spotify_id: track["id"],
      number_of_singers: track["artists"].count,
      year: get_year(track),
      artist: track["artists"].map { |artist| artist["name"] }.join(", "),
      popularity: track["popularity"],
      duration_ms: track["duration_ms"],
      image_url: track["album"]["images"][0]&.dig("url"),
    }
  end

  def get_year(track)
    release_date_precision = track["album"]["release_date_precision"]
    release_date = track["album"]["release_date"]
    case release_date_precision
    when "year"
      release_date
    when "day"
      release_date[0,4]
    else
      nil
    end
  end
end