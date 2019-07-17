# @summary Manages the configuration files on your Cassandra nodes
#
# This class is managing the following files:
# * /var/lib/cassandra/.cassandra.in.sh
# * /etc/cassandra/cassandra-rackdc.properties
# * /etc/cassandra/cassandra.yaml
# * /etc/cassandra/jvm.options
#
# The main class of this module will include this class, you should not
# invoke this at all.
#
# All parameter necessery for this class are defined in the main class.
#
# The `config` parameter should contain only those settings you want
# to have non-default, i.e. want to change on the node. Keep in mind,
# that the structure of this hash must fit to the structure of
# `cassandra.yaml`.
#
# @example main config file handling
#   cassandra::config:
#     cluster_name: Example Cassandra cluster
#     endpoint_snitch: PropertyFileSnitch
#     seed_provider:
#       - class_name: org.apache.cassandra.locator.SimpleSeedProvider
#         parameters:
#           - seeds: 10.0.0.1,10.0.1.1
#     listen_address: %{facts.networking.ip}
class cassandra::config {
  concat { $cassandra::envfile:
    ensure         => present,
    ensure_newline => true,
  }
  concat::fragment { 'cassandra.in.sh header':
    target => $cassandra::envfile,
    order  => '01',
    source => 'puppet:///modules/cassandra/cassandra.in.sh.header',
  }

  $cassandra::environment.each |String $name, String $value| {
    cassandra::environment::variable { $name: value => $value, }
  }
  $cassandra::jvm_options.each |String $name| {
    cassandra::environment::jvm_option { $name: }
  }
  merge({}, $cassandra::java['properties']).each |String $name, $value| {
    cassandra::java::property { $name: value => $value, }
  }
  merge({}, $cassandra::java['agents']).each |String $name, $value| {
    cassandra::java::agent { $name: value => $value, }
  }
  merge({}, $cassandra::java['runtime_options']).each |String $name, $value| {
    cassandra::java::runtimeoption { $name: value => $value, }
  }
  merge({}, $cassandra::java['adv_runtime_options']).each |String $name, $value| {
    cassandra::java::advancedruntimeoption { $name: value => $value, }
  }
  if $cassandra::java_gc {
    class { 'cassandra::java::gc':
      * => $cassandra::java_gc,
    }
  }

  contain cassandra::config::rackdc

  # Merge cassandra.yaml with config hash on the target node
  yaml_settings {'cassandra::config':
    target => "${cassandra::config_dir}/cassandra.yaml",
    values => $cassandra::config,
  }
}
