require 'rubygems'
require 'rake'

begin
  require "lib/facade_builder"

  include Shortwave::Facade::Build
  namespace :facade do
    directory "tmp/lastfm"

    task :scrape_method_index => "tmp/lastfm" do
      REMOTE_METHODS = FacadeBuilder.new.remote_method_definitions("tmp/lastfm/intro.yml")
    end

    task :scrape => :scrape_method_index do
      methods = REMOTE_METHODS.values.inject {|a, b| a.merge(b) }
      methods.each do |name, uri|
        if ! File.exists?("tmp/lastfm/#{name}.html")
          response = DocumentationRemote.get(uri)
          File.open("tmp/lastfm/#{name}.html", "w") {|fh| fh.write(response) }
          warn "Got HTML documentation for #{name}"
        end
      end
    end

    task :parse => :scrape do
      KLASSES = REMOTE_METHODS.map do |klass_name, methods|
        warn "Building #{klass_name}"
        methods.keys.inject(RubyClass.new(klass_name)) do |klass, method_name|
          warn "  building #{method_name}"
          klass.methods << RubyMethod.new( RemoteMethod.new( File.read("tmp/lastfm/#{method_name}.html")))
          klass
        end
      end
    end

    # Fixes any ommissions or mistakes in the HTML documentation
    task :patch => :parse do
    end

    desc "Scrapes the HTML documentation from the Last.FM site and uses it to construct ruby facade objects"
    task :build => [:parse, :patch] do
      klasses = KLASSES
      File.open("lib/lastfm.rb", "w") do |fh|
        fh.write ERB.new(File.read("lib/facade_template.erb")).result(binding)
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
    gem.summary = %Q{TODO}
    gem.email = "roland.swingler@gmail.com"
    gem.homepage = "http://github.com/knaveofdiamonds/shortwave"
    gem.authors = ["Roland Swingler"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
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

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "shortwave #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

