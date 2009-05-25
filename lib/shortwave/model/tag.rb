module Shortwave
  module Model
    class Tag
      include HappyMapper
      
      tag 'tag'
      element :name, String
      element :count, Integer
      element :url, String
      element :streamable, Boolean

      attr_writer :session

      def similar
        response = facade.similar(name)
        self.class.parse(response).each {|tag| tag.session = @session }
      end

      private

      def facade
        @session.tag_facade
      end
    end
  end
end
