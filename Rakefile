require 'rubygems'
require 'rake'

begin
  require "lib/shortwave/facade/build/facade_builder"

  include Shortwave::Facade::Build
  namespace :facade do
    directory "tmp/lastfm"

    task :scrape_method_index => "tmp/lastfm" do
      REMOTE_METHOD_DEFINITIONS = FacadeBuilder.new.remote_method_definitions("tmp/lastfm/intro.yml")
    end

    task :scrape => :scrape_method_index do
      methods = REMOTE_METHOD_DEFINITIONS.values.inject {|a, b| a.merge(b) }
      methods.each do |name, uri|
        if ! File.exists?("tmp/lastfm/#{name}.html")
          response = DocumentationRemote.get(uri)
          File.open("tmp/lastfm/#{name}.html", "w") {|fh| fh.write(response) }
          warn "Got HTML documentation for #{name}"
        end
      end
    end

    task :parse => :scrape do
      REMOTE_METHODS = {}
      REMOTE_METHOD_DEFINITIONS.each do |klass_name, methods|
        REMOTE_METHODS[klass_name] = []
        methods.keys.each do |method_name|
          warn "parsing #{method_name}"
          REMOTE_METHODS[klass_name] << RemoteMethod.new( File.read("tmp/lastfm/#{method_name}.html"))
        end
      end
    end

    # Fixes any ommissions or mistakes in the HTML documentation
    task :patch => :parse do
      patch_methods "Tag", :top_artists, :top_tracks, :top_albums do |method|
        method.parameters << Parameter.new(:tag, true, "Last.fm tag")
      end
      patch_methods "Group", :weekly_album_chart do |method|
        method.parameters.delete_if {|p| p.name == :user}
        method.parameters << Parameter.new(:group, true, "Group name")
      end
    end

    def patch_methods(klass, *methods, &block)
      REMOTE_METHODS[klass].select {|m| methods.include?(m.name) }.each do |method|
        yield method
      end
    end

    task :build => :patch do
      KLASSES = REMOTE_METHODS.map do |klass_name, methods|
        warn "Building #{klass_name}"
        methods.inject(RubyClass.new(klass_name)) do |klass, method|
          klass.methods << RubyMethod.new(method)
          klass
        end
      end
    end

    desc "Scrapes the HTML documentation from the Last.FM site and uses it to construct ruby facade objects"
    task :compile => :build do
      klasses = KLASSES
      File.open("lib/shortwave/facade/lastfm.rb", "w") do |fh|
        fh.write ERB.new(File.read("lib/shortwave/facade/build/facade_template.erb")).result(binding)
      end
    end
  end

rescue LoadError
  warn "Cannot build a fresh Facade::Remote - missing gems (nokogiri)?"
end


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "shortwave"
    gem.summary = "A Last.fm API wrapper"
    gem.email = "roland.swingler@gmail.com"
    gem.homepage = "http://shortwave.rubyforge.org"
    gem.authors = ["Roland Swingler"]
    gem.add_dependency("rest-client", ">= 0.9.2")
    gem.add_dependency("nokogiri", ">= 1.2.3")
    gem.rubyforge_project = "shortwave"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end


task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'doc'
  rdoc.title = "shortwave #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/*.rb')
  rdoc.rdoc_files.include('lib/shortwave/*.rb')
  rdoc.rdoc_files.include('lib/shortwave/facade/*.rb')
  rdoc.rdoc_files.include('lib/shortwave/model/*.rb')
end
