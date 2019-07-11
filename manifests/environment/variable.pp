# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   cassandra::environment::variable { 'namevar': }
define cassandra::environment::variable (
  String $value,
  String $id = $title,
) {
  concat::fragment{ "cassandra::environment::variable[${id}]=${value}":
    target   => $cassandra::envfile,
    order    => '10',
    content  => inline_epp('<%= $name %>="<%= $val -%>"',
      'name' => $id,
      'val'  => $value,
    )
  }
}
