module Shortwave
  module Model
    # Root class for all Shortwave models.
    class BaseModel
      # Sets the session on this model, and all nested models
      def session=(session)
        @session = session
        self.class.has_ones.each do |sym| 
          obj = send(sym)
          obj.session = session if obj
        end
        self.class.has_manys.each {|s| (send(s) || []).each {|o| o.session = session } }
        session
      end

      def self.inherited(klass)
        klass.send(:include, HappyMapper)
        klass.send(:tag, klass.name.split("::").last.downcase)

        # Store every has_one/has_many declaration and use this information
        # to decide which attributes need a session adding
        class << klass
          def has_ones
            @has_ones ||= []
          end

          def has_manys 
            @has_manys ||= []
          end

          def has_one(sym, *args)
            super
            has_ones << sym
          end

          def has_many(sym, *args)
            super
            has_manys << sym
          end
        end
      end
    end
  end
end
