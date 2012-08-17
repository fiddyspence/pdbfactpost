module Puppet::Parser::Functions
  newfunction(:pdbfactpost, :type => :rvalue, :doc => "\

    ") do |args|
    require 'rubygems'
    require 'json'
    require 'puppet/network/http_pool'
    require 'uri'
#    require 'puppet/util/puppetdb'
    require 'puppet/util/puppetdb/char_encoding'
    require 'digest'
    require 'puppet/node'
    require 'puppet/node/facts'

    raise Puppet::ParseError, "pdbfactpost:  requires 2 arguments, a host and a hash of data" unless args.length == 2
    raise Puppet::ParseError, "pdbfactpost:  please supply a host as argument 1" unless args[0].is_a?(String)
    raise Puppet::ParseError, "pdbfactpost:  please supply a data hash as argument 2" unless args[1].is_a?(Hash) 

    Puppet.parse_config

    def format_command(payload, command, version)
      message = {
        :command => command,
        :version => version,
        :payload => payload.to_pson,
      }.to_pson

      Puppet::Util::Puppetdb::CharEncoding.utf8_string(message)
    end

    # Query type (URL path)
    urlpath = "/commands"
    command = "replace facts"
    version = 1
    payload=Puppet::Node::Facts.new(args[0],args[1])

    message = format_command(payload,command,version)

    url = URI.parse("https://#{Puppet::Util::Puppetdb.server}:#{Puppet::Util::Puppetdb.port}#{urlpath}")
    
    req = Net::HTTP::Post.new(url.request_uri)
    req.set_form_data("payload" => message)
    req['Accept'] = 'application/json'
    conn = Puppet::Network::HttpPool.http_instance(url.host, url.port,
                                                   ssl=(url.scheme == 'https'))
    conn.start {|http|
      response = http.request(req)
      unless response.kind_of?(Net::HTTPSuccess)
        raise Puppet::ParseError, "PuppetDB query error: [#{response.code}] #{response.msg}"
      end
      JSON.parse(response.body)
    }
  end
end
