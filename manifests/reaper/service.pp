# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cassandra::reaper::service
class cassandra::reaper::service {
  service { 'cassandra-reaper':
    ensure => $cassandra::reaper::service_ensure,
    enable => $cassandra::reaper::service_enable,
  }
}
