# @summary Do not include this class for its own.
#
# Managing the service of a cassandra reaper instance.
# 
# This class is included by cassandra::reaper and should not be used otherwise.
#
class cassandra::reaper::service {
  service { 'cassandra-reaper':
    ensure => $cassandra::reaper::service_ensure,
    enable => $cassandra::reaper::service_enable,
  }
}
