# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cassandra::config
class cassandra::config {
  # setup environment include file
  concat { $cassandra::envfile:
    ensure         => present,
    ensure_newline => true,
  }
  concat::fragment { 'cassandra.in.sh header':
    target => $cassandra::envfile,
    order  => '01',
    source => 'puppet:///modules/cassandra/cassandra.in.sh.header',
  }

  $cassandra::environment.each |String $name, String $value| {
    cassandra::environment::variable { $name: value => $value, }
  }
  $cassandra::jvm_options.each |String $name| {
    cassandra::environment::jvm_option { $name: }
  }
  merge({}, $cassandra::java['properties']).each |String $name, $value| {
    cassandra::java::property { $name: value => $value, }
  }
  merge({}, $cassandra::java['agents']).each |String $name, $value| {
    cassandra::java::agent { $name: value => $value, }
  }
  merge({}, $cassandra::java['runtime_options']).each |String $name, $value| {
    cassandra::java::runtimeoption { $name: value => $value, }
  }
  merge({}, $cassandra::java['adv_runtime_options']).each |String $name, $value| {
    cassandra::java::advancedruntimeoption { $name: value => $value, }
  }

  contain cassandra::config::rackdc

  # Merge cassandra.yaml with config hash on the target node
  yaml_settings {'cassandra::config':
    target => "${cassandra::config_dir}/cassandra.yaml",
    values => $cassandra::config,
  }
}
