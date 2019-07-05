# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   cassandra::environment::jvm_option { 'namevar': }
define cassandra::environment::jvm_option (
) {
  cassandra::environment::variable{ 'JVM_EXTRA_OPTS':
    value => "\$JVM_EXTRA_OPTS ${name}",
  }
}
