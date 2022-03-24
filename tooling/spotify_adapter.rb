require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class SpotifyAdapter
	def initialize(api_key:)
		@api_key = api_key
	end

	def get_playlist_tracks(playlist_id)
		url = URI("https://spotify23.p.rapidapi.com/playlist_tracks/?id=#{playlist_id}&offset=0&limit=100")

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Get.new(url)
		request["X-RapidAPI-Host"] = 'spotify23.p.rapidapi.com'
		request["X-RapidAPI-Key"] = @api_key

		response = http.request(request)
		body = response.read_body
		json = JSON.parse(body)
		items = json["items"]
		items.map do |item|
			convert_track(item["track"])
		end
	end

	def convert_track(track)
		{
			title: track["name"],
			spotify_id: track["id"],
			number_of_singers: track["artists"].count,
			year: get_year(track),
			artist: track["artists"].map { |artist| artist["name"] }.join(", "),
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