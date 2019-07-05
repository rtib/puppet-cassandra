# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   cassandra::java::agent { 'namevar': }
define cassandra::java::agent (
  Optional[String] $value = undef,
) {
  $_opt = inline_epp('-javaagent:<%= $prop -%><% if $value { -%>=<%= $value -%><% } -%>"',
      'prop'  => $name,
      'value' => $value,
    )
  cassandra::environment::jvm_option { $_opt: }
}
