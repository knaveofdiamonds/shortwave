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

      # Adds methods to a model to deal with shouts: shouts and shout
      def self.shoutable(*methods)
        class_eval <<-EOV
          def shouts
            response = @session.#{tag_name}_facade.shouts(#{methods.join(",")})
            Shout.parse(response).each {|s| s.session = @session }
          end

          def shout(message)
            @session.#{tag_name}_facade.shout(#{methods.join(",")}, message)
          end
        EOV
      end

      # Adds methods to a model to deal with tags: tags, add_tags and remove_tag
      #
      # Up to ten tags can be added, either strings, or Tag models
      # A single tag can be removed
      def self.taggable(*methods)
        class_eval <<-EOV
          def add_tags(*tags)
            tag_param = tags[0...10].map {|t| t.to_s }.join(",")
            @session.#{tag_name}_facade.add_tags(#{methods.join(",")}, tag_param)
          end

          def remove_tag(tag)
            @session.#{tag_name}_facade.remove_tag(#{methods.join(",")}, tag.to_s)
          end

          def tags
            @session.#{tag_name}_facade.tags(#{methods.join(",")})
          end
        EOV
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
