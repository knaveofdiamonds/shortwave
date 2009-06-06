module Shortwave
  module Provider
    # Intended to be mixed in to authentication classes
    module ProviderMethods
      [:album, :artist, :group, :location, :playlist, :track, :tag, :user, :venue].each do |name|
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

      def location_facade
        @location_facade ||= Facade::Geo.new(self)            
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

      protected

      # Defines a search method on this provider
      def self.searchable
        define_method :search do |name|
          parse_collection @facade.search(name)
        end
      end

      def self.identifiable_by_mbid
        define_method :get_by_id do |mbid|
          mbid = mbid.uuid if mbid.respond_to? :uuid
          parse_model @facade.info(:mbid => mbid)
        end
      end

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

    class PlaylistProvider < BaseProvider
      def create(title, description=nil)
        hsh = description ? {:description => description} : {}
        parse_model @facade.create(hsh.merge(:title => title))
      end
    end

    # Produces album objects.
    class AlbumProvider < BaseProvider
      searchable
      identifiable_by_mbid

      # Gets an album, given an artist name and an album name
      def get(artist, name)
        parse_model @facade.info(:artist => artist, :album => name)
      end
    end


    # Produces artist objects.
    class ArtistProvider < BaseProvider
      searchable
      identifiable_by_mbid

      def get(artist)
        parse_model @facade.info(:artist => artist)
      end
    end


    class GroupProvider < BaseProvider
    end


    # Locations can only be built
    class LocationProvider < BaseProvider
    end


    # Produces Tag objects
    class TagProvider < BaseProvider
      searchable

      # Returns a tag named "name"
      def get(name)
        parse_model @facade.search(name)
      end

      # Returns the most popular tags from Last.fm
      def popular
        parse_collection @facade.top_tags
      end
    end


    # Produces track objects.
    class TrackProvider < BaseProvider
      searchable
      identifiable_by_mbid

      # Gets a track, given an artist name and a track name
      def get(artist, name)
        parse_model @facade.info(:artist => artist, :track => name)
      end
    end


    # Produces Venue objects
    class VenueProvider < BaseProvider
      def search(name, country=nil)
        hsh = {}
        hsh[:country] = country if country
        parse_collection @facade.search(name, hsh)
      end
    end


    class UserProvider < BaseProvider
      def logged_in_user
        parse_model @facade.info
      end
    end
  end
end
