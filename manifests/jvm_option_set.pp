# @summary Set JVM options by controlling particular lines of jvm.options file.
#
# Select the file to be controlled by choosing, jvm, jvm8 or jvm11 and the
# variant server or clients. Options, properties and advanced runtime options
# can be defined to have particular values or to be removed from the configuration.
# Any option not mentioned will not be touched.
#
# For Cassandra 3.x versions, only `optsfile = jvm` with `variant = undef` is supported,
# which will control the `/etc/cassandra/jvm.options` file. Since Cassandra versions >= 4.0
# use distinct option files for server and clients, as well as Java independent, Java-8 and
# Java-11, use parameters `optsfile` and `variant` to select a particular options file.
#
# @param optsfile
#   determine the file to control, either `jvm` for the independet
#   options or `jvm8`, `jvm11` or `jvm17` for the version dependant options
# @param variant
#   leave this undef for Cassandra < 4.0, set it to `server` or `clients` if running >= 4.0
# @param options
#   list of basic JVM options, e.g. `ea`, `server`, `Xms4g`, etc.
# @param properties
#   java properties to be passed to the JVM
# @param sizeoptions
#   JVM options having a value concatenated directly to the options, e.g. `Xmx4g`.
# @param advancedoptions
#   advanced runtime options which may be feature toggles or values
define cassandra::jvm_option_set (
  Enum['jvm', 'jvm8', 'jvm11', 'jvm17'] $optsfile = 'jvm',
  Optional[Enum['clients', 'server']]   $variant = undef,
  Array[String]                         $options = [],
  Hash[String,Optional[Scalar]]         $properties = {},
  Hash[String,Optional[Scalar]]         $sizeoptions = {},
  Hash[String,Optional[Scalar]]         $advancedoptions = {},
) {
  $_file = $variant ? {
    /^(server|clients)$/ => "${cassandra::config_dir}/${optsfile}-${variant}.options",
    default              => "${cassandra::config_dir}/${optsfile}.options",
  }

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

  $sizeoptions.each |String $_prop, Data $_value| {
    if $_value =~ Undef {
      file_line { "${name} remove size option ${_prop}":
        ensure            => absent,
        path              => $_file,
        match             => "^-${_prop}",
        match_for_absence => true,
      }
    } else {
      file_line { "${name} set size option ${_prop}":
        ensure => present,
        path   => $_file,
        match  => "^-${_prop}",
        line   => "-${_prop}${_value}",
      }
    }
  } # $sizeoptions.each

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
