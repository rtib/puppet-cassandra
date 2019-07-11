# @summary This is the main entry point and API for Cassandra module.
#
# Puppet module for Cassandra cluster which enables to install, configure and manage Cassandra nodes.
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
# @param config_dir
#   cassandra configuration directory
# @param config
#   configuration hash to be merged with local cassandra.yaml on the node
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
  Hash                        $config = {},
  Stdlib::Absolutepath        $cassandra_home = '/var/lib/cassandra',
  Stdlib::Absolutepath        $envfile = "${cassandra_home}/.cassandra.in.sh",
  Optional[Cassandra::Rackdc] $rackdc = undef,
  Optional[Hash]              $topology = undef,
  Optional[Pattern[/[a-zA-Z0-9.]:[a-zA-Z0-9.-]/]]
                              $topology_default  = undef,
) {
  contain cassandra::install
  contain cassandra::config
  contain cassandra::service

  Class['cassandra::install']
  -> Class['cassandra::config']
  ~> Class['cassandra::service']
}
