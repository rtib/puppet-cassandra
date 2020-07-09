# @summary Set JVM options by controlling particular lines of jvm.options file.
#
# Select the file to be controlled by choosing, jvm, jvm8 or jvm11 and the
# variant server or clients. Options, properties and advanced runtime options
# can be defined to have particular values or to be removed from the configuration.
# Any option not mentioned will not be touched.
#
# @param optsfile determine the file to control, either `jvm` for the independet
#    options or `jvm8` or `jvm11` for the version dependant options
# @param variant options variant to be used for
# @param options list of basic JVM options, e.g. `ea`, `server`, `Xms4g`, etc.
# @param properties java properties to be passed to the JVM
# @param advancedoptions advanced runtime options which may be feature toggles or values
define cassandra::jvm_option_set (
  Enum['jvm', 'jvm8', 'jvm11']  $optsfile = 'jvm',
  Enum['clients', 'server']     $variant = 'server',
  Array[String]                 $options = [],
  Hash[String,Optional[Scalar]] $properties = {},
  Hash[String,Optional[Scalar]] $advancedoptions = {},
) {
  # ToDo: we need jvm.options to be handled as well for < 4.0
  $_file = "${cassandra::config_dir}/${optsfile}-${variant}.options"

  $options.each |String $_opt| {
    if $_opt =~ /^~/ {
      $_value = $_opt[1,-1]
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
    if $_value =~ Undef {
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
    if $_value =~ Undef {
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
