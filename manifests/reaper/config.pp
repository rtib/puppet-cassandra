# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cassandra::reaper::config
class cassandra::reaper::config (
  Optional[String]     $template = undef,
  Hash                 $settings = {},
  Stdlib::Absolutepath $configdir = '/etc/cassandra-reaper',
  Stdlib::Absolutepath $templatedir = "${configdir}/configs",
) {
  $_source = $template ? {
    undef   => undef,
    default => "${templatedir}/${template}.yaml"
  }
  yaml_settings {'cassandra::reaper::config':
    source => $_source,
    target => "${configdir}/cassandra-reaper.yaml",
    values => $settings,
  }
}
