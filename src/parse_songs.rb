require 'csv'
require 'json'

rows = CSV.read('src/songs.csv', headers: true)
json_blob = rows.map { |row| row.to_hash }.to_json
File.write('src/songs.json', json_blob)