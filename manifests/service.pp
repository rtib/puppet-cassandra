# @summary Controls the service
#
# This class is controlling the Cassandra service on the nodes. Take
# care of the fact, that configuration changes will notify the service
# which may lead to onorchestrated node restarts on your cluster.
#
# You probably don't want this happen in production.
#
class cassandra::service {
  if $cassandra::manage_service {
    service { $cassandra::service_name:
      ensure => $cassandra::service_ensure,
      enable => $cassandra::service_enable,
    }
  }
}
