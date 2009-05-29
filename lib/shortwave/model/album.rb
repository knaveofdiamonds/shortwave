module Shortwave
  module Model
    class Album < BaseModel
      element :name, String, :tag => "name|title"
      element :url, String
      element :id, Integer
      element :release_date, Time, :tag => "releasedate"
      element :listeners, Integer
      element :play_count, Integer, :tag => "playcount"
      element :images, String, :tag => "image", :single => false
      element :mbid, String
      element :artist_name, String, :tag => "artist"
      has_many :top_tags, "Shortwave::Model::Tag", :tag => "toptags/tag"

      identified_by :artist_name, :name
      taggable
    end
  end
end
