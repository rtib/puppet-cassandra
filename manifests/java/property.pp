# @summary Add a Java property to the JVM running Cassandra.
#
# Each instance of this type adds a property to the JVM running
# Cassandra.
#
# The `config` class contains a factory for this type which will
# create instances for each key of `cassandra::java::properties`.
#
# @example directly created
#   cassandra::java::property { 'cassandra.replace_address':
#     value => '10.0.0.2'
#   }
#
# @example factory generated
#    cassandra::java:
#      properties:
#        cassandra.consistent.rangemovement: false
#        cassandra.replace_address: 10.0.0.2
#
# @param value
#   the value the property is set to
#
define cassandra::java::property (
  Scalar $value,
) {
  cassandra::environment::jvm_option{ "D${name}=${value}": }
}
