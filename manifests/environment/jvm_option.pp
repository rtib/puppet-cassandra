# @summary Creates a JVM option for Cassandra.
#
# Each instance of this type is adding a JVM option to
# the JVM running the Cassandra. This enables you to set e.g.
# `verbose:gc`.
#
# The `config` class contains a factory for this type which will create
# instances for each key of `cassandra::jvm_options`.
#
# @example directly created
#    cassandra::jvm_option { 'verbose:gc': }
#
# @example factory generated
#    cassandra::jvm_options:
#      - verbose:gc
#      - server
define cassandra::environment::jvm_option (
) {
  cassandra::environment::variable { "cassandra::environment::jvm_option[${name}]":
    id    => 'JVM_EXTRA_OPTS',
    value => "\$JVM_EXTRA_OPTS -${name}",
  }
}
