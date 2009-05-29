module Shortwave
  module Provider
    # Intended to be mixed in to authentication classes
    module ProviderMethods
      [:album, :artist, :track, :tag, :user, :venue].each do |name|
        klass_name = name.to_s.capitalize
        module_eval <<-EOV
          def #{name}
            @#{name}_provider ||= Provider::#{klass_name}Provider.new(#{name}_facade)
          end

          def #{name}_facade
            @#{name}_facade ||= Facade::#{klass_name}.new(self)            
          end
        EOV
      end
    end


    # You should generally use an instance of this class provided by a session:
    # session.album
    class BaseProvider
      # Creates a provider with a facade
      def initialize(facade)
        @klass  = Model.const_get(self.class.name.split("::").last.sub("Provider",''))
        @facade = facade
      end

      # Builds a model object.
      def build(attributes)
        model = @klass.new
        attributes.each {|attr, value| model.send("#{attr}=".to_sym, value) }
        model.session = @facade.session
        model
      end

      # Searches for the model by name.
      def search(name)
        parse_collection @facade.search(name)
      end

      protected

      # Parses an xml response into a Shortwave::Model::* object
      def parse_model(response)
        model = @klass.parse(response, :single => true)
        model.session = @facade.session
        model
      end

      # Parses an xml response into an array of  Shortwave::Model::* objects
      def parse_collection(response)
        @klass.parse(response).each {|model| model.session = @facade.session }
      end
    end


    # Produces album objects.
    class AlbumProvider < BaseProvider
      # Gets an album, given a musicbrainz id.
      def get(mbid)
        parse_model @facade.info(:mbid => mbid)
      end

      # Gets an album, given an artist name and an album name
      def get_by_name(artist, name)
        parse_model @facade.info(:artist => artist, :album => name)
      end
    end


    # Produces artist objects.
    #
    # You should generally use an instance of this class provided by a session:
    # session.artist
    class ArtistProvider < BaseProvider
      # Returns an artist, given either an artist's name or a musicbrainz id
      def get(identifier)
        key = (identifier =~ /[\da-f]{8}-[\da-f]{4}-[\da-f]{4}-[\da-f]{4}-[\da-f]{12}/) ? :mbid : :artist
        parse_model @facade.info(key => identifier)
      end
    end


    # Produces Tag objects
    class TagProvider < BaseProvider
      # Returns a tag named "name"
      def get(name)
        parse_model @facade.search(name)
      end

      # Returns the most popular tags from Last.fm
      def popular
        parse_collection @facade.top_tags
      end
    end

    # Produces Venue objects
    class VenueProvider < BaseProvider
    end


    # Produces track objects.
    class TrackProvider < BaseProvider
      # Gets an track, given a musicbrainz id.
      def get(mbid)
        parse_model @facade.info(:mbid => mbid)
      end

      # Gets a track, given an artist name and a track name
      def get_by_name(artist, name)
        parse_model @facade.info(:artist => artist, :track => name)
      end
    end

    class UserProvider < BaseProvider
    end
  end
end
