# @summary Do not include this class for its own.
#
# Managing the configuration of a cassandra reaper instance.
# 
# This class is included by cassandra::reaper and should not be used otherwise.
#
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
