# @summary Creating an environment variable for Cassandra.
#
# Each instance of this type is adding a environment variable to
# the Cassandra process. This enables you to set e.g. `MAX_HEAP_SIZE`,
# `HEAP_NEWSIZE`, etc.
#
# The `config` class contains a factory for this type which will create
# instances for each key of `cassandra::environment`.
#
# @example directly created
#    cassandra::environment::variable { 'MAX_HEAP_SIZE': 
#      value => '8G',
#    }
#
# @example factory generated
#    cassandra::environment:
#      MAX_HEAP_SIZE: 8G
#      HEAP_NEWSIZE: 2G
#
# @param id
#   name of the environment variable
# @param value
#   value to be assigned to the variable
#
define cassandra::environment::variable (
  String $value,
  String $id = $title,
) {
  concat::fragment { "cassandra::environment::variable[${id}]=${value}":
    target  => $cassandra::envfile,
    order   => '10',
    content => inline_epp('<%= $name %>="<%= $val -%>"',
      {
        'name' => $id,
        'val'  => $value,
      }
    ),
  }
}
