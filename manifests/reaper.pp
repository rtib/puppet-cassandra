# @summary Manage a cassandra-reaper instance
#
# This class is installing and managing an instance of cassandra-repear.
#
# @example
#   include cassandra::reaper
#
# @param package_ensure
#   package state to be ensured
#
# @param template
#   select the configuration template to which the settings are going to be merged
#
# @param settings
#   hash of cassandra-reaper settings to be merged
#
# @param configdir
#   directory where to place the configuration file
#
# @param templatedir
#   directory containing the template configurations
#
# @param service_ensure
#   serivce state to be ensured
#
# @param service_enable
#   whether to enable or disable the service
#
class cassandra::reaper (
  # install params
  String                     $package_ensure = 'latest',
  # config params
  Optional[String]           $template = undef,
  Hash                       $settings = {},
  Stdlib::Absolutepath       $configdir = '/etc/cassandra-reaper',
  Stdlib::Absolutepath       $templatedir = "${configdir}/configs",
  # service params
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
