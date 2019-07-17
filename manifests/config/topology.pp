# @summary Class to manage the cassandra-topology.properties file
#
# This class manages the cassandra-topology.properties file, which is needed
# when using PropertyFileSnitch or GossippingPropertyFileSnitch.
#
# This class is contained with config, thus do not use it for its own.
#
# @example multi-dc and multi-rack topology
#    cassandra::topology:
#      dc1:
#        rackA:
#        - 10.0.0.1
#        - 10.0.0.2
#        rackB:
#        - 10.0.0.3
#        - 10.0.0.4
#      dc2:
#        rackA:
#        - 10.0.1.1
#        - 10.0.1.2
#        rackB:
#        - 10.0.1.3
#        - 10.0.1.4
#
# @example setting up topology_default
#    cassandra::topology:
#      dc1:
#        rackA:
#        - 10.0.0.1
#        - 10.0.0.2
#        rackB:
#        - 10.0.0.3
#        - 10.0.0.4
#      dc2:
#        rackA:
#        - 10.0.1.1
#        - 10.0.1.2
#        rackB:
#        - 10.0.1.3
#        - 10.0.1.4
#    cassandra::topology_default: dc1:rackA
#
class cassandra::config::topology {
  $path = "${cassandra::config_dir}/cassandra-topology.properties"

  if $cassandra::topology =~ Hash {
    file { $path:
      ensure  => 'file',
      content => epp('cassandra/cassandra-topology.properties.epp'),
    }
  } else {
    file { $path:
      ensure => 'absent',
    }
  }
}
