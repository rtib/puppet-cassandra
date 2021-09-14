# @summary Setup the Java garbage collection for Cassandra
#
# *Depricated!*: This class is now deprecated. Consider using JVM option sets instead.
#
# This class allows to set consistent JVM options at once, especially for the
# purpose of garbage collection settings. This is enabled by managing
# jvm.options file, available from Cassandra version 3.0 and later.
#
# GC parameters could be:
# * common parameters
#   * numberOfGCLogFiles (Integer, defaults to: 10) - -XX:NumberOfGCLogFiles
#   * gCLogFileSize (String, defaults to: 10M) - -XX:GCLogFileSize
# * G1 specific parameters
#   * maxGCPauseMillis (Integer, defaults to: 500) - -XX:MaxGCPauseMillis
#   * g1RSetUpdatingPauseTimePercent (Integer, defaults to: 5) - -XX:G1RSetUpdatingPauseTimePercent
#   * initiatingHeapOccupancyPercent (Integer, defaults to: 70) - -XX:InitiatingHeapOccupancyPercent
#   * parallelGCThreads (Optional[Integer], defaults to: undef) - -XX:ParallelGCThreads automatically set to number or cores-2 if >10
#       cores present
#   * concGCThreads (Optional[Integer], defaults to: undef) - -XX:ConcGCThreads automatically set to -XX:ParallelGCThreads if the above is
#       set
#
# The `config` class contains a factory for this class which will create
# an instance using the settings of `cassandra::java_gc`, if not undef.
#
# @example directly created
#   class { 'cassandra::java::gc':
#     collector => 'g1',
#   }
#
# @example factory generated
#    cassandra::java_gc:
#      collector: g1
#      params:
#        maxGCPauseMillis: 300
#
# @param collector
#   select the garbage collector to use
# @param params
#   parameter to set up the selected GC
class cassandra::java::gc (
  Enum['cms','g1']  $collector,
  Hash[String,Data] $params = {},
) {
  notify { 'The class cassandra::java::gc is deprecated now, consider using cassandra::jvm_option_sets instead!':
    loglevel => warning,
  }
  file{ "${cassandra::config_dir}/jvm.options":
    ensure  => file,
    content => epp("cassandra/jvm.${collector}.options.epp", $params),
  }
}
