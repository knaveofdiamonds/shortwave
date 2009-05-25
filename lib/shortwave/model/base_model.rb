module Shortwave
  module Model
    class BaseModel
      attr_writer :session

      def self.inherited(klass)
        klass.send(:include, HappyMapper)
        klass.send(:tag, klass.name.split("::").last.downcase)
      end

    end
  end
end
