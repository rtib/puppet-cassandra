# @summary This is the main entry point and API for Cassandra module.
#
# Puppet module for Cassandra cluster which enables to install, configure and manage Cassandra nodes.
# The module consists of the `install` class, which is included first, followed by `config` and
# `config::topology` classes. Finally, the `service` class is included and notification from `config`
# are forwarded to `service`.
#
# This class is the main class of this module and the only one which should be
# included in your node manifests. For documentation of the particular feature,
# refer to the reference documentation of the other components.
#
# @example
#   include cassandra
#
# @param cassandra_package
#   name of the package to be installed
# @param cassandra_ensure
#   ensure clause for cassandra package
# @param tools_package
#   package name of cassandra tools
# @param tools_ensure
#   ensure clause for tools package
# @param manage_service
#   enables puppet to manage the service
# @param service_ensure
#   ensure clause for cassandra service
# @param service_enable
#   enable state of cassandra service
# @param service_name
#   the name of the cassandra service
# @param config_dir
#   cassandra configuration directory
# @param environment
#   hash of environment variable name-value pairs which should be add
# @param jvm_options
#   list of options to be passed to the JVM
# @param java
#   input hash to the factory of java properties, agents, runtime_options and advanced_runtime_options
# @param java_gc
#   input hash to the `java::gc` class
# @param config
#   configuration hash to be merged with local cassandra.yaml on the node
# @param initial_tokens
#   mapping inital token to nodes and merge them into the config
# @param node_key
#   the key used in initial_tokens to identify nodes
# @param cassandra_home
#   homedirectory of cassandra user
# @param envfile
#   envfile path containing environment settings
# @param rackdc
#   rack and dc settings to be used by GossipingPropertyFileSnitch
# @param topology
#   hash describing the topology to be used by PropertyFileSnitch and GossipingPropertyFileSnitch
# @param topology_default
#   default dc and rack settings
class cassandra (
  String                      $cassandra_package = 'cassandra',
  String                      $cassandra_ensure = 'installed',
  String                      $tools_package = 'cassandra-tools',
  String                      $tools_ensure = $cassandra_ensure,
  Boolean                     $manage_service = true,
  Cassandra::Service::Ensure  $service_ensure = undef,
  Cassandra::Service::Enable  $service_enable = 'manual',
  String                      $service_name = 'cassandra',
  Stdlib::Absolutepath        $config_dir = '/etc/cassandra',
  Hash                        $environment = {},
  Array[String]               $jvm_options = [],
  Struct[{
    properties          => Optional[Hash],
    agents              => Optional[Hash],
    runtime_options     => Optional[Hash],
    adv_runtime_options => Optional[Hash],
  }]                          $java = {},
  Optional[Hash]              $java_gc = undef,
  Hash                        $config = {},
  Optional[Hash[Stdlib::Host,Pattern[/^[0-9]+$/]]]
                              $initial_tokens = undef,
  Stdlib::Host                $node_key = $facts['networking']['fqdn'],
  Stdlib::Absolutepath        $cassandra_home = '/var/lib/cassandra',
  Stdlib::Absolutepath        $envfile = "${cassandra_home}/.cassandra.in.sh",
  Optional[Cassandra::Rackdc] $rackdc = undef,
  Optional[Hash]              $topology = undef,
  Optional[Pattern[/[a-zA-Z0-9.]:[a-zA-Z0-9.-]/]]
                              $topology_default  = undef,
) {
  contain cassandra::install
  contain cassandra::config
  contain cassandra::config::topology
  contain cassandra::service

  Class['cassandra::install']
  -> Class['cassandra::config']
  ~> Class['cassandra::service']
  Class['cassandra::install']
  -> Class['cassandra::config::topology']
}
