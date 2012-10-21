# Rack::Auth::Ip
middleware to restrict ip address

== Synopsis

in your_app.ru
  require 'rack/auth/ip'
  # allow access only local network
  use Rack::Auth::IP, %w( 192.168.0.0/24 )

  # you can use block
  # ip is IPAddr instance.
  use Rack::Auth::IP do |ip|
    Your::Model::IP.count({ :ip => ip.to_s }) != 0 
  end

== Description
middleware to restrict ip address

## Installation

Add this line to your application's Gemfile:

    gem 'rack-auth-ip'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-auth-ip

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
