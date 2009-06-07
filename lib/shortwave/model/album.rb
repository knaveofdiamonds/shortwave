module Shortwave
  module Model
    # An album on Last.fm
    #
    # === Attributes
    #
    # +name+:: Album name
    # +url+:: Last.fm site url
    # +id+:: Last.fm id
    # +release_date+:: Release date
    # +listeners+:: Number of listeners
    # +play_count+:: Number of times tracks from this album have been played
    # +images+:: An array of album images
    # +mbid+:: Musicbrainz ID
    # +artist_name+:: Album's artist
    # +tags+:: Last.fm user tags
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
      has_many :tags, "Shortwave::Model::Tag", :tag => "toptags/tag"

      identified_by :artist_name, :name
      taggable
    end
  end
end
