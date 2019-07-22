# @summary Add an agent to the JVM running Cassandra.
#
# Each instance of this type adds an agent to the JVM running
# Cassandra.
#
# The `config` class contains a factory for this type which will
# create instances for each key of `cassandra::java::agents`.
#
# @example directly created
#   cassandra::java::agent { 'jmx_prometheus_javaagent.jar':
#     value => '8080:config.yaml',
#   }
#
# @example factory created
#    cassandra::java:
#      agents:
#        jmx_prometheus_javaagent.jar: 8080:config.yaml
#
# @param value
#   options to be added to the agent
#
define cassandra::java::agent (
  Optional[String] $value = undef,
) {
  $_opt = inline_epp('javaagent:<%= $prop -%><% if $value { -%>=<%= $value -%><% } -%>',
    {
      'prop'  => $name,
      'value' => $value,
    }
  )
  cassandra::environment::jvm_option { $_opt: }
}
