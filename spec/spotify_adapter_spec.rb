require_relative './spec_helper.rb'
require_relative '../tooling/spotify_adapter.rb'

describe SpotifyAdapter do
	let(:instance) { described_class.new(api_key: api_key) }
	let(:api_key) { 'test' }

	describe 'get_playlist_tracks' do
		subject { instance.get_playlist_tracks(playlist_id) }
		let(:playlist_id) { 'playlist_id' }

		before do
			stub_request(:get, /spotify23.p.rapidapi.com/).to_return(
				status: 200,
				body: File.read(File.join(File.dirname(__FILE__), './fixtures/playlist_tracks.json')),
			)
		end

		it 'returns data in the expected structure' do
			expect(subject).to eq([
	      {
	      	:artist=>"Journey",
	        :number_of_singers=>1,
	        :spotify_id=>"4bHsxqR3GMrXTxEPLuK5ue",
	        :title=>"Don't Stop Believin'",
	        :year=>"1981",
	      },
	      {
	      	:artist=>"Lady Gaga, Bradley Cooper",
	        :number_of_singers=>2,
	        :spotify_id=>"2VxeLyX666F8uXCJ0dZF8B",
	        :title=>"Shallow",
	        :year=>"2018",
	      },
			])
		end
	end
end