$LOAD_PATH.unshift(File.dirname(__FILE__) + "/shortwave")
$LOAD_PATH.unshift(File.dirname(__FILE__) + "/../vendor/happymapper/lib")
require 'happymapper'
require 'facade'
require 'providers'
require 'authentication'
require 'model/base_model'
Dir[File.dirname(__FILE__) + "/shortwave/model/*.rb"].each {|model| require model }

