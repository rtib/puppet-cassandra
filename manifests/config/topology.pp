# @summary Class to manage the cassandra-topology.properties file
#
# This class allows to manage the cassandra-topology.properties file, which is needed
# when using PropertyFileSnitch or GossippingPropertyFileSnitch.
#
# This class is contained with config, thus do not use it for its own.
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
