# @summary Do not include this class for its own.
#
# Installing a cassandra reaper instance.
# 
# This class is included by cassandra::reaper and should not be used otherwise.
#
class cassandra::reaper::install {
  package{ 'reaper':
    ensure => $cassandra::reaper::package_ensure,
  }
}
