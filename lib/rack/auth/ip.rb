require 'ipaddr'
module Rack
  module Auth
    # in your_app.ru
    #   require 'rack/auth/ip'
    #   # allow access only local network
    #   use Rack::Auth::IP, %w( 192.168.0.0/24 )

    #   # you can use block
    #   # ip is IPAddr instance.
    #   use Rack::Auth::IP do |ip|
    #     Your::Model::IP.count({ :ip => ip.to_s }) != 0 
    #   end
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

      def initialize app, ip_list=nil, &block
        @app = app
        @ip_list = ip_list

        if @ip_list 
          @ip_list = @ip_list.map {|ip| IPAddr.new(ip) }
        end

        @cond = block
      end

      def call env
        req_ip = IPAddr.new(detect_ip(env))

        if @ip_list
          if @ip_list.find {|ip| ip.include? req_ip }
            return @app.call(env)
          end
        else
          if @cond && @cond.call(req_ip)
            return @app.call(env)
          end
        end
        return [403, {'Content-Type' => 'text/plain' }, 'Forbidden' ]
      end
    end
  end
end
