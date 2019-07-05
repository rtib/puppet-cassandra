# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cassandra::install
class cassandra::install {
  package { $cassandra::cassandra_package:
    ensure => $cassandra::cassandra_ensure,
  }

  package { $cassandra::tools_package:
    ensure => $cassandra::tools_ensure,
  }
}
