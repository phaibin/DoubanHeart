require 'data_mapper'

class HotelDetail
  include DataMapper::Resource

  property :id, Serial
  property :url, String, length: 300
  property :data, Text
  property :created_at, DateTime
  property :updated_at, DateTime
end