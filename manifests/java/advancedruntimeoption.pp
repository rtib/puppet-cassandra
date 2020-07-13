# @summary Add an advanced runtime option to the JVM running Cassandra.
#
# Each instance of this type adds a advanced runtime option to the JVM running
# Cassandra.
#
# The `config` class contains a factory for this type which will
# create instances for each key of `cassandra::java::runtime_options`.
#
# @example directly created
#   cassandra::java::advancedruntimeoption { 'LargePageSizeInBytes':
#     value => '2m',
#   }
#
# @example factory generated
#    cassandra::java:
#      adv_runtime_options:
#        LargePageSizeInBytes: 2m
#        UseLargePages: true
#        AlwaysPreTouch: true
#
# @param value
#   a string value to be added to the runtime option or a boolean
#   which will prefix the option with + or -
#
define cassandra::java::advancedruntimeoption (
  Scalar $value,
) {
  $_opt = $value ? {
    Boolean => inline_epp('XX:<% if $value { -%>+<% } else { -%>-<% } -%><%= $name %>',
      {
        'name'  => $name,
        'value' => $value,
      }),
    default  => inline_epp('XX:<%= $name -%>=<%= $value %>',
      {
        'name'  => $name,
        'value' => $value,
      }),
  }
  cassandra::environment::jvm_option { $_opt: }
}
