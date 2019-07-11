# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   cassandra::java::property { 'namevar': }
define cassandra::java::property (
  String $value,
) {
  cassandra::environment::jvm_option{ "D${name}=${value}": }
}
