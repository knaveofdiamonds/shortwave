require 'rubygems'
require 'test/unit'
require 'mocha'
require 'fakeweb'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'shortwave'

FakeWeb.allow_net_connect = false
TestCase = Test::Unit::TestCase

class TestCase
  def setup
    FakeWeb.clean_registry
  end

  def self.test(name, &block)
    test_name = "test_#{name.gsub(/\s+/, '_')}".to_sym
    defined = instance_method(test_name) rescue false
    raise "#{test_name} is already defined in #{self}" if defined

    if block_given?
      define_method(test_name, &block)
    else
      define_method(test_name) do
        flunk "No implementation for #{test_name}"
      end
    end
  end
end

include Shortwave
require 'provider_test_helper'

