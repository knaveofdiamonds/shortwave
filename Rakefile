require 'rubygems'
require 'rake'


begin
  require "lib/facade_builder"
  include Shortwave::Facade
  namespace :facade do
    directory "tmp/lastfm"

    desc "Scrape method documentation from last.fm"
    task :scrape => "tmp/lastfm" do
      remote_methods = Build::DocumentationRemote.scrape_remote_method_uris
      remote_methods.each do |name, uri|
        if ! File.exists?("tmp/lastfm/#{name}.html")
          response = Build::DocumentationRemote.get(uri)
          File.open("tmp/lastfm/#{name}.html", "w") {|fh| fh.write(response) }
          warn "Got HTML documentation for #{name}"
        end
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

