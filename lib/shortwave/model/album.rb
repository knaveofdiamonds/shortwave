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

      # Adds tags to this album on Last.fm
      #
      # +tags+:: up to ten tags, either strings, or Tag models
      def add_tags(*tags)
        tag_param = tags[0...10].map {|t| t.to_s }.join(",")
        @session.album_facade.add_tags(artist_name, name, tag_param)
      end

      # Removes a tag from this album on Last.fm
      #
      # +tag+:: A tag, either a string or a Tag model
      def remove_tag(tag)
        @session.album_facade.remove_tag(artist_name, name, tag.to_s)
      end
    end
  end
end
