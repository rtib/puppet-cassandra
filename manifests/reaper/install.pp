# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cassandra::reaper::install
class cassandra::reaper::install {
  package{ 'reaper':
    ensure => $cassandra::reaper::package_ensure,
  }
}
