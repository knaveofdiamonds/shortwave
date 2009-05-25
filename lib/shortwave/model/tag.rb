module Shortwave
  module Model
    class Tag < BaseModel
      element :name, String
      element :count, Integer
      element :url, String
      element :streamable, Boolean

      def similar
        response = @session.tag_facade.similar(name)
        self.class.parse(response).each {|tag| tag.session = @session }
      end
    end
  end
end
