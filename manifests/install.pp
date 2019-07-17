# @summary Installs the Cassandra packages.
#
# This class is installing the Cassandra and optionally the Tools
# packages.
#
# The main class of this module will include this class, you should not
# invoke this at all.
#
# All parameter necessery for this class are defined in the main class.
#
# @example install a specific version
#   cassandra::cassandra_ensure: 3.0.18
#
# @example to install the latest version of cassandra-tools, independently from the cassandra version above
#   cassandra::tools_ensure: latest
#
# @example if you don't want to install the tools package
#   cassandra::tools_ensure: absent
#
# @example in the case, your package name is other
#   cassandra::cassandra_package: dsc22
#
class cassandra::install {
  package { $cassandra::cassandra_package:
    ensure => $cassandra::cassandra_ensure,
  }

  package { $cassandra::tools_package:
    ensure => $cassandra::tools_ensure,
  }
}
