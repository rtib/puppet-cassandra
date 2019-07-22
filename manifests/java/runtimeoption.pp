# @summary Add a runtime option to the JVM running Cassandra.
#
# Each instance of this type adds a runtime option to the JVM running
# Cassandra.
#
# The `config` class contains a factory for this type which will
# create instances for each key of `cassandra::java::runtime_options`.
#
# @example directly created
#   cassandra::java::runtimeoption { 'prof': }
#
# @example factory generated
#    cassandra::java:
#      runtime_options:
#        check: jni
#        prof:
#
# @param value
#   value to be added to the runtime option 
#
define cassandra::java::runtimeoption (
  Optional[String] $value = undef,
) {
  $_opt = inline_epp('X<%= $prop -%><% if $value { -%>:<%= $value -%><% } -%>',
    {
      'prop'  => $name,
      'value' => $value,
    }
  )
  cassandra::environment::jvm_option { $_opt: }
}
