require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rack/auth/ip'
require 'ipaddr'

module Rack::Auth::IP::CustomMatchers
  class BeForbidden
    def matches? actual
      @actual = actual
      actual[0] == 403
    end

    def failure_message
      "expected status code 403 #{@actual.inspect}"
    end
  end

  def be_forbidden
    BeForbidden.new
  end
end

describe Rack::Auth::IP do
  describe 'detect_ip' do
    it 'should return REMOTE_ADDR if not exists HTTP_X_FORWARDED_FOR' do
      Rack::Auth::IP::Util.detect_ip({"REMOTE_ADDR" => '127.0.0.1'}).should == '127.0.0.1'
    end

    it 'should return HTTP_X_FORWARDED_FOR if exists HTTP_X_FORWARDED_FOR' do
      Rack::Auth::IP::Util.detect_ip({'HTTP_X_FORWARDED_FOR' => '192.168.0.1', "REMOTE_ADDR" => '127.0.0.1'}).should == '192.168.0.1'
    end

    it 'should return last HTTP_X_FORWARDED_FOR if HTTP_X_FORWARDED_FOR has multi address' do
      Rack::Auth::IP::Util.detect_ip({'HTTP_X_FORWARDED_FOR' => '192.168.0.1,192.168.0.2', "REMOTE_ADDR" => '127.0.0.1'}).should == '192.168.0.2'
    end
  end

  describe 'when with block' do
    before do
      @env = { "REMOTE_ADDR" => '127.0.0.1' }
      @app = proc {|env| env }
    end

    it 'should recieve IPAddr instance in block' do
      Rack::Auth::IP.new(@app) {|ip|
        ip.should == IPAddr.new(@env["REMOTE_ADDR"])
      }.call(@env)
    end
  end

  describe 'with ip list' do
    include Rack::Auth::IP::CustomMatchers

    before do
      @env = { "REMOTE_ADDR" => '127.0.0.1' }
      @app = proc {|env| env }
    end

    it 'should be forbidden when ip list is blank' do
      Rack::Auth::IP.new(@app, []).call(@env).should be_forbidden
    end

    it 'should be forbidden when ip list dose not match' do
      Rack::Auth::IP.new(@app, ['192.168.0.1']).call(@env).should be_forbidden
    end

    it 'should run app when request ip is match' do
      Rack::Auth::IP.new(@app, ['127.0.0.1']).call(@env).should == @app.call(@env)
    end

    it 'should run app when request ip in list' do
      Rack::Auth::IP.new(@app, %w(192.168.0.1 127.0.0.1)).call(@env).should == @app.call(@env)
    end

    it 'can use mask as ip' do
      Rack::Auth::IP.new(@app, %w(127.0.0.0/24)).call(@env).should == @app.call(@env)
    end
  end
end
