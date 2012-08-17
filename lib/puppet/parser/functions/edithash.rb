module Puppet::Parser::Functions
  newfunction(:edithash, :type => :rvalue, :doc => "\

    ") do |args|

    raise Puppet::ParseError, "pdbfactpost:  requires 3 arguments, a host and a hash of data" unless args.length == 3
    raise Puppet::ParseError, "pdbfactpost:  please supply a host as argument 1" unless args[0].is_a?(Hash)
    raise Puppet::ParseError, "pdbfactpost:  please supply a data hash as argument 2" unless args[1].is_a?(String) 
    raise Puppet::ParseError, "pdbfactpost:  please supply a data hash as argument 2" unless args[2]

    thehash = args[0]
    raise Puppet::ParseError, "pdbfactpost:  please supply a data hash as argument 2" unless thehash[args[1]]
    
    thehash[args[1]] = args[2]

    return thehash
    
  end
end
