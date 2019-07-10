# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cassandra::service
class cassandra::service {
  if $cassandra::manage_service {
    service { $cassandra::service_name:
      ensure => $cassandra::service_ensure,
      enable => $cassandra::service_enable,
    }
  }
}
