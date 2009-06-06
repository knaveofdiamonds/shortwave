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

      class << self
        def facade_name
          @facade_name ||= (name.split("::").last.downcase + "_facade").to_sym
        end

        def identified_by(*methods)
          @lastfm_keys = methods
        end

        # Adds methods to a model to deal with shouts: shouts and shout
        def shoutable
          class_eval <<-EOV
            def shout(message)
              @session.#{facade_name}.shout(#{@lastfm_keys.join(",")}, message)
            end

            link_to "Shout", :shouts
          EOV
        end

        # Adds methods to a model to deal with tags: tags, add_tags and remove_tag
        #
        # Up to ten tags can be added, either strings, or Tag models
        # A single tag can be removed
        def taggable
          class_eval <<-EOV
            def add_tags(*tags)
              tag_param = tags[0...10].map {|t| t.to_s }.join(",")
              @session.#{facade_name}.add_tags(#{@lastfm_keys.join(",")}, tag_param)
            end

            def remove_tag(tag)
              @session.#{facade_name}.remove_tag(#{@lastfm_keys.join(",")}, tag.to_s)
            end

            link_to "Tag", :my_tags, :tags
          EOV
        end

        def sharable
          class_eval <<-EOV
            def share(recipients, message=nil)
              params = {}
              params[:message] = message if message
              @session.#{facade_name}.share(#{@lastfm_keys.join(",")}, recipients[0...10].map{|r| r.to_s }.join(','), params)
            end
          EOV
        end

        def link_to(klass, method, remote_method=nil)
          remote_method ||= method
          class_eval <<-EOV
            def #{method}
              response = @session.#{facade_name}.#{remote_method}(#{@lastfm_keys.join(',')}) 
              #{klass}.parse(response).each {|obj| obj.session = @session }
            end
          EOV
        end

        def inherited(klass)
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
      
      protected

      def link(remote_method, klass, *args)
        response = @session.send(self.class.facade_name).send(remote_method, *args) 
        klass = ::Shortwave::Model.const_get(klass)
        klass.parse(response).each {|obj| obj.session = @session }
      end
    end
  end
end
