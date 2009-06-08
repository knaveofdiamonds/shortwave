module Shortwave
  module Model
    # A comparison between two Last.fm users
    #
    # === Attributes
    # 
    # +score+:: A number between 0 and 1 representing how similar users are.
    # +artists+:: Artists both users have in common
    class Comparison < BaseModel
      tag "comparison"
      element :score, Float, :tag => "result/score"
      has_many :artists, "Model::Artist", :tag => "result/artists/artist"
    end
  end
end
