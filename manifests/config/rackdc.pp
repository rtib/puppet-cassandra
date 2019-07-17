# @summary Class to manage the `cassandra-rackdc.properties` file
#
# This class manages the cassandra-rackdc.properties file, which is needed
# when using GossippingPropertyFileSnitch.
#
# This class is contained with config, thus do not use it for its own.
#
# @example simple rack and DC settings
#    cassandra::rackdc:
#      dc: dc1
#      rack: rackA
#
# @example rack, DC and dc_suffix settings
#    cassandra::rackdc:
#      dc: dc1
#      rack: rackA
#      dc_suffix: .example.org
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
