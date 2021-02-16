# @summary Manage a cassandra-reaper instance
#
# This class is installing and managing an instance of cassandra-repear.
#
# @example
#   include cassandra::reaper
class cassandra::reaper (
  String                     $package_ensure = 'latest',
  Cassandra::Service::Ensure $service_ensure = 'running',
  Cassandra::Service::Enable $service_enable = true,
) {
  contain cassandra::reaper::install
  contain cassandra::reaper::config
  contain cassandra::reaper::service

  Class['cassandra::reaper::install']
  -> Class['cassandra::reaper::config']
  ~> Class['cassandra::reaper::service']
}
