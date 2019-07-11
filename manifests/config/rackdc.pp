# @summary Class to manage the cassandra-rackdc.properties file
#
# This class allows to manage the cassandra-rackdc.properties file, which is needed
# when using GossippingPropertyFileSnitch.
#
# This class is contained with config, thus do not use it for its own.
#
class cassandra::config::rackdc {
  $path = "${cassandra::config_dir}/cassandra-rackdc.properties"

  if $cassandra::rackdc =~ Hash {
    file { $path:
      ensure  => 'file',
      content => epp('cassandra/cassandra-rackdc.properties.epp'),
    }
  } else {
    file { $path:
      ensure => 'absent',
    }
  }
}
