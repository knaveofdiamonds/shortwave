module Shortwave
  module Model
    class Artist < BaseModel
      element :name, String
      element :mbid, String
      element :url, String
      element :streamable, Boolean
      element :play_count, Integer, :tag => "stats/playcount"
      element :listeners, Integer, :tag => "stats/listeners"
      element :biography_summary, String, :tag => "bio/content"
      element :biography, String, :tag => "bio/content"
      element :images, String, :tag => "image", :single => false

      identified_by :name
      taggable
      shoutable
    end
  end
end
