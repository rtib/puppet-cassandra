# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cassandra::config
class cassandra::config(
  Stdlib::AbsolutePath $envfile = "${cassandra::cassandra_home}/.cassandra.in.sh"
) {
  # setup environment include file
  concat { $envfile:
    ensure         => present,
    ensure_newline => true,
  }
  concat::fragment { 'cassandra.in.sh header':
    target => $envfile,
    order  => '01',
    source => 'puppet:///modules/cassandra/cassandra.in.sh.header',
  }

  contain cassandra::config::topology
  contain cassandra::config::rackdc

  # Merge cassandra.yaml with config hash on the target node
  yaml_settings {'cassandra::config':
    target => "${cassandra::config_dir}/cassandra.yaml",
    values => $cassandra::config,
  }
}
