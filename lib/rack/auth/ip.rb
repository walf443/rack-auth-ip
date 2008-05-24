require 'ipaddr'
require 'rack/auth/abstract/handler'
require 'rack/auth/abstract/request'
module Rack
  module Auth
    class IP
      module Util
        # consider using reverse proxy
        def detect_ip env
          if env['HTTP_X_FORWARDED_FOR']
            env['HTTP_X_FORWARDED_FOR'].split(',').pop
          else
            env["REMOTE_ADDR"]
          end
        end

        module_function :detect_ip
      end
      include Util

      def initialize app, ip_list=nil
        @app = app
        @ip_list = ip_list

        if @ip_list 
          @ip_list = @ip_list.map {|ip| IPAddr.new(ip) }
        end
      end

      def call env
        req_ip = IPAddr.new(detect_ip(env))

        if @ip_list
          if @ip_list.find {|ip| ip.include? req_ip }
            return @app.call(env)
          end
        else
          if yield(req_ip)
            return @app.call(env)
          end
        end
        return [403, {}, 'Forbidden' ]
      end
    end
  end
end
