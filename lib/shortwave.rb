$LOAD_PATH.unshift(File.dirname(__FILE__) + "/shortwave")
require 'happymapper'
require 'facade'
require 'authentication'
require 'provider/base'
require 'model/base_model'
Dir[File.dirname(__FILE__) + "/shortwave/model/*.rb"].each {|model| require model }
Dir[File.dirname(__FILE__) + "/shortwave/provider/*.rb"].each {|provider| require provider }

