# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cassandra::reaper::config
class cassandra::reaper::config {
  $_source = $cassandra::reaper::template ? {
    undef   => undef,
    default => "${cassandra::reaper::templatedir}/${cassandra::reaper::template}.yaml"
  }
  yaml_settings {'cassandra::reaper::config':
    source => $_source,
    target => "${cassandra::reaper::configdir}/cassandra-reaper.yaml",
    values => $cassandra::reaper::settings,
  }
}
