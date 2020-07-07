# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   cassandra::jvm_option_set { 'namevar': }
define cassandra::jvm_option_set (
  Enum['jvm', 'jvm8', 'jvm11']  $optsfile = 'jvm',
  Enum['clients', 'server']     $variant = 'server',
  Array[String]                 $options = [],
  Hash[String,Optional[Scalar]] $properties = {},
  Hash[String,Optional[Scalar]] $advancedoptions = {},
) {
  $_file = "${cassandra::config_dir}/${optsfile}-${variant}.options"

  $options.each |String $_opt| {
    if $_opt ~= /^~/ {
      $_value = ${_opt[2,-1]}
      file_line { "${name} remove option ${_value}":
        ensure => absent,
        path   => $_file,
        line   => "-${_value}",
      }
    } else {
      file_line { "${name} set option ${_opt}":
        ensure => present,
        path   => $_file,
        line   => "-${_opt}",
      }
    }
  } # $options.each

  $properties.each |String $_prop, Data $_value| {
    if ! $_value {
      file_line { "${name} remove property ${_prop}":
        ensure            => absent,
        path              => $_file,
        match             => "^-D${_prop}",
        match_for_absence => true,
      }
    } else {
      file_line { "${name} set property ${_prop}":
        ensure => present,
        path   => $_file,
        match  => "^-D${_prop}",
        line   => "-D${_prop}=${_value}",
      }
    }
  } # $properties.each

  $advancedoptions.each |String $_aopt, Data $_value| {
    if ! $_value {
      file_line { "${name} remove advanced runtime option ${_aopt}":
        ensure            => absent,
        path              => $_file,
        match             => "^-XX:[+-]?${_aopt}",
        match_for_absence => true,
      }
    } else {
      if $_value =~ Boolean {
        $_pre = $_value ? {
          true    => '+',
          default => '-',
        }
        file_line { "${name} set boolean advanced runtime option ${_aopt}":
          ensure => present,
          path   => $_file,
          match  => "^-XX:[+-]${_aopt}",
          line   => "-XX:${_pre}${_aopt}",
        }
      } else {
        file_line { "${name} set advanced runtime option ${_aopt}":
          ensure => present,
          path   => $_file,
          match  => "^-XX:${_aopt}",
          line   => "-XX:${_aopt}=${_value}",
        }
      }
    }
  }
}
