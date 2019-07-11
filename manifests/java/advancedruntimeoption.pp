# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   cassandra::java::advancedruntimeoption { 'namevar': }
define cassandra::java::advancedruntimeoption (
  Variant[Boolean,String] $value,
) {
  $_opt = $value ? {
    Boolean => inline_epp('XX:<% if $value { -%>+<% } else { -%>-<% } -%><%= $name %>',
                  'name'  => $name,
                  'value' => $value,
                ),
    String  => inline_epp('XX:<%= $name -%>=<%= $value %>',
                  'name'  => $name,
                  'value' => $value,
                ),
    default => '',
  }
  cassandra::environment::jvm_option { $_opt: }
}
