# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Classes**

* [`cassandra`](#cassandra): This is the main entry point and API for Cassandra module.
* [`cassandra::config`](#cassandraconfig): Manages the configuration files on your Cassandra nodes
* [`cassandra::config::rackdc`](#cassandraconfigrackdc): Class to manage the `cassandra-rackdc.properties` file
* [`cassandra::config::topology`](#cassandraconfigtopology): Class to manage the cassandra-topology.properties file
* [`cassandra::install`](#cassandrainstall): Installs the Cassandra packages.
* [`cassandra::java::gc`](#cassandrajavagc): Setup the Java garbage collection for Cassandra
* [`cassandra::service`](#cassandraservice): Controls the service

**Defined types**

* [`cassandra::environment::jvm_option`](#cassandraenvironmentjvm_option): Creates a JVM option for Cassandra.
* [`cassandra::environment::variable`](#cassandraenvironmentvariable): Creating an environment variable for Cassandra.
* [`cassandra::java::advancedruntimeoption`](#cassandrajavaadvancedruntimeoption): Add an advanced runtime option to the JVM running Cassandra.
* [`cassandra::java::agent`](#cassandrajavaagent): Add an agent to the JVM running Cassandra.
* [`cassandra::java::property`](#cassandrajavaproperty): Add a Java property to the JVM running Cassandra.
* [`cassandra::java::runtimeoption`](#cassandrajavaruntimeoption): Add a runtime option to the JVM running Cassandra.

**Data types**

* [`Cassandra::Rackdc`](#cassandrarackdc): Hash allowing to setup the content of `cassandra-rackdc.properties`. Note, that the fields `dc` and `rack` mandatory to setup rackdc, while `
* [`Cassandra::Service::Enable`](#cassandraserviceenable): Service enable can be `manual` or `mask` besides the Boolean.
* [`Cassandra::Service::Ensure`](#cassandraserviceensure): This type is simply missing from Stdlib.

## Classes

### cassandra

Puppet module for Cassandra cluster which enables to install, configure and manage Cassandra nodes.
The module consists of the `install` class, which is included first, followed by `config` and
`config::topology` classes. Finally, the `service` class is included and notification from `config`
are forwarded to `service`.

This class is the main class of this module and the only one which should be
included in your node manifests. For documentation of the particular feature,
refer to the reference documentation of the other components.

#### Examples

##### 

```puppet
include cassandra
```

#### Parameters

The following parameters are available in the `cassandra` class.

##### `cassandra_package`

Data type: `String`

name of the package to be installed

Default value: 'cassandra'

##### `cassandra_ensure`

Data type: `String`

ensure clause for cassandra package

Default value: 'installed'

##### `tools_package`

Data type: `String`

package name of cassandra tools

Default value: 'cassandra-tools'

##### `tools_ensure`

Data type: `String`

ensure clause for tools package

Default value: $cassandra_ensure

##### `manage_service`

Data type: `Boolean`

enables puppet to manage the service

Default value: `true`

##### `service_ensure`

Data type: `Cassandra::Service::Ensure`

ensure clause for cassandra service

Default value: `undef`

##### `service_enable`

Data type: `Cassandra::Service::Enable`

enable state of cassandra service

Default value: 'manual'

##### `service_name`

Data type: `String`

the name of the cassandra service

Default value: 'cassandra'

##### `config_dir`

Data type: `Stdlib::Absolutepath`

cassandra configuration directory

Default value: '/etc/cassandra'

##### `environment`

Data type: `Hash`

hash of environment variable name-value pairs which should be add

Default value: {}

##### `jvm_options`

Data type: `Array[String]`

list of options to be passed to the JVM

Default value: []

##### `java`

Data type: `Struct[{
    properties          => Optional[Hash],
    agents              => Optional[Hash],
    runtime_options     => Optional[Hash],
    adv_runtime_options => Optional[Hash],
  }]`

input hash to the factory of java properties, agents, runtime_options and advanced_runtime_options

Default value: {}

##### `java_gc`

Data type: `Optional[Hash]`

input hash to the `java::gc` class

Default value: `undef`

##### `config`

Data type: `Hash`

configuration hash to be merged with local cassandra.yaml on the node

Default value: {}

##### `initial_tokens`

Data type: `Optional[Hash[Stdlib::Host,Pattern[/^[0-9]+$/]]]`

mapping inital token to nodes and merge them into the config

Default value: `undef`

##### `node_key`

Data type: `Stdlib::Host`

the key used in initial_tokens to identify nodes

Default value: $facts['networking']['fqdn']

##### `cassandra_home`

Data type: `Stdlib::Absolutepath`

homedirectory of cassandra user

Default value: '/var/lib/cassandra'

##### `envfile`

Data type: `Stdlib::Absolutepath`

envfile path containing environment settings

Default value: "${cassandra_home}/.cassandra.in.sh"

##### `rackdc`

Data type: `Optional[Cassandra::Rackdc]`

rack and dc settings to be used by GossipingPropertyFileSnitch

Default value: `undef`

##### `topology`

Data type: `Optional[Hash]`

hash describing the topology to be used by PropertyFileSnitch and GossipingPropertyFileSnitch

Default value: `undef`

##### `topology_default`

Data type: `Optional[Pattern[/[a-zA-Z0-9.]:[a-zA-Z0-9.-]/]]`

default dc and rack settings

Default value: `undef`

### cassandra::config

This class is managing the following files:
* /var/lib/cassandra/.cassandra.in.sh
* /etc/cassandra/cassandra-rackdc.properties
* /etc/cassandra/cassandra.yaml
* /etc/cassandra/jvm.options

The main class of this module will include this class, you should not
invoke this at all.

All parameter necessery for this class are defined in the main class.

The `config` parameter should contain only those settings you want
to have non-default, i.e. want to change on the node. Keep in mind,
that the structure of this hash must fit to the structure of
`cassandra.yaml`.

#### Examples

##### main config file handling

```puppet
cassandra::config:
  cluster_name: Example Cassandra cluster
  endpoint_snitch: PropertyFileSnitch
  seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
      parameters:
        - seeds: 10.0.0.1,10.0.1.1
  listen_address: "%{facts.networking.ip}"
```

### cassandra::config::rackdc

This class manages the cassandra-rackdc.properties file, which is needed
when using GossippingPropertyFileSnitch.

This class is contained with config, thus do not use it for its own.

#### Examples

##### simple rack and DC settings

```puppet
cassandra::rackdc:
  dc: dc1
  rack: rackA
```

##### rack, DC and dc_suffix settings

```puppet
cassandra::rackdc:
  dc: dc1
  rack: rackA
  dc_suffix: .example.org
```

### cassandra::config::topology

This class manages the cassandra-topology.properties file, which is needed
when using PropertyFileSnitch or GossippingPropertyFileSnitch.

This class is contained with config, thus do not use it for its own.

#### Examples

##### multi-dc and multi-rack topology

```puppet
cassandra::topology:
  dc1:
    rackA:
    - 10.0.0.1
    - 10.0.0.2
    rackB:
    - 10.0.0.3
    - 10.0.0.4
  dc2:
    rackA:
    - 10.0.1.1
    - 10.0.1.2
    rackB:
    - 10.0.1.3
    - 10.0.1.4
```

##### setting up topology_default

```puppet
cassandra::topology:
  dc1:
    rackA:
    - 10.0.0.1
    - 10.0.0.2
    rackB:
    - 10.0.0.3
    - 10.0.0.4
  dc2:
    rackA:
    - 10.0.1.1
    - 10.0.1.2
    rackB:
    - 10.0.1.3
    - 10.0.1.4
cassandra::topology_default: dc1:rackA
```

### cassandra::install

This class is installing the Cassandra and optionally the Tools
packages.

The main class of this module will include this class, you should not
invoke this at all.

All parameter necessery for this class are defined in the main class.

#### Examples

##### install a specific version

```puppet
cassandra::cassandra_ensure: 3.0.18
```

##### to install the latest version of cassandra-tools, independently from the cassandra version above

```puppet
cassandra::tools_ensure: latest
```

##### if you don't want to install the tools package

```puppet
cassandra::tools_ensure: absent
```

##### in the case, your package name is other

```puppet
cassandra::cassandra_package: dsc22
```

### cassandra::java::gc

This class allows to set consistent JVM options at once, especially for the
purpose of garbage collection settings. This is enabled by managing
jvm.options file, available from Cassandra version 3.0 and later.

GC parameters could be:
* common parameters
  * numberOfGCLogFiles (Integer, defaults to: 10) - -XX:NumberOfGCLogFiles
  * gCLogFileSize (String, defaults to: 10M) - -XX:GCLogFileSize
* G1 specific parameters
  * maxGCPauseMillis (Integer, defaults to: 500) - -XX:MaxGCPauseMillis
  * g1RSetUpdatingPauseTimePercent (Integer, defaults to: 5) - -XX:G1RSetUpdatingPauseTimePercent
  * initiatingHeapOccupancyPercent (Integer, defaults to: 70) - -XX:InitiatingHeapOccupancyPercent
  * parallelGCThreads (Optional[Integer], defaults to: undef) - -XX:ParallelGCThreads automatically set to number or cores-2 if >10
      cores present
  * concGCThreads (Optional[Integer], defaults to: undef) - -XX:ConcGCThreads automatically set to -XX:ParallelGCThreads if the above is
      set

The `config` class contains a factory for this class which will create
an instance using the settings of `cassandra::java_gc`, if not undef.

#### Examples

##### directly created

```puppet
class { 'cassandra::java::gc':
  collector => 'g1',
}
```

##### factory generated

```puppet
cassandra::java_gc:
  collector: g1
  params:
    maxGCPauseMillis: 300
```

#### Parameters

The following parameters are available in the `cassandra::java::gc` class.

##### `collector`

Data type: `Enum['cms','g1']`

select the garbage collector to use

##### `params`

Data type: `Hash[String,Data]`

parameter to set up the selected GC

Default value: {}

### cassandra::service

This class is controlling the Cassandra service on the nodes. Take
care of the fact, that configuration changes will notify the service
which may lead to onorchestrated node restarts on your cluster.

You probably don't want this happen in production.

## Defined types

### cassandra::environment::jvm_option

Each instance of this type is adding a JVM option to
the JVM running the Cassandra. This enables you to set e.g.
`verbose:gc`.

The `config` class contains a factory for this type which will create
instances for each key of `cassandra::jvm_options`.

#### Examples

##### directly created

```puppet
cassandra::jvm_option { 'verbose:gc': }
```

##### factory generated

```puppet
cassandra::jvm_options:
  - verbose:gc
  - server
```

### cassandra::environment::variable

Each instance of this type is adding a environment variable to
the Cassandra process. This enables you to set e.g. `MAX_HEAP_SIZE`,
`HEAP_NEWSIZE`, etc.

The `config` class contains a factory for this type which will create
instances for each key of `cassandra::environment`.

#### Examples

##### directly created

```puppet
cassandra::environment::variable { 'MAX_HEAP_SIZE':
  value => '8G',
}
```

##### factory generated

```puppet
cassandra::environment:
  MAX_HEAP_SIZE: 8G
  HEAP_NEWSIZE: 2G
```

#### Parameters

The following parameters are available in the `cassandra::environment::variable` defined type.

##### `id`

Data type: `String`

name of the environment variable

Default value: $title

##### `value`

Data type: `String`

value to be assigned to the variable

### cassandra::java::advancedruntimeoption

Each instance of this type adds a advanced runtime option to the JVM running
Cassandra.

The `config` class contains a factory for this type which will
create instances for each key of `cassandra::java::runtime_options`.

#### Examples

##### directly created

```puppet
cassandra::java::advancedruntimeoption { 'LargePageSizeInBytes':
  value => '2m',
}
```

##### factory generated

```puppet
cassandra::java:
  adv_runtime_options:
    LargePageSizeInBytes: 2m
    UseLargePages: true
    AlwaysPreTouch: true
```

#### Parameters

The following parameters are available in the `cassandra::java::advancedruntimeoption` defined type.

##### `value`

Data type: `Variant[Boolean,String]`

a string value to be added to the runtime option or a boolean
which will prefix the option with + or -

### cassandra::java::agent

Each instance of this type adds an agent to the JVM running
Cassandra.

The `config` class contains a factory for this type which will
create instances for each key of `cassandra::java::agents`.

#### Examples

##### directly created

```puppet
cassandra::java::agent { 'jmx_prometheus_javaagent.jar':
  value => '8080:config.yaml',
}
```

##### factory created

```puppet
cassandra::java:
  agents:
    jmx_prometheus_javaagent.jar: 8080:config.yaml
```

#### Parameters

The following parameters are available in the `cassandra::java::agent` defined type.

##### `value`

Data type: `Optional[String]`

options to be added to the agent

Default value: `undef`

### cassandra::java::property

Each instance of this type adds a property to the JVM running
Cassandra.

The `config` class contains a factory for this type which will
create instances for each key of `cassandra::java::properties`.

#### Examples

##### directly created

```puppet
cassandra::java::property { 'cassandra.replace_address':
  value => '10.0.0.2'
}
```

##### factory generated

```puppet
cassandra::java:
  properties:
    cassandra.consistent.rangemovement: false
    cassandra.replace_address: 10.0.0.2
```

#### Parameters

The following parameters are available in the `cassandra::java::property` defined type.

##### `value`

Data type: `String`

the value the property is set to

### cassandra::java::runtimeoption

Each instance of this type adds a runtime option to the JVM running
Cassandra.

The `config` class contains a factory for this type which will
create instances for each key of `cassandra::java::runtime_options`.

#### Examples

##### directly created

```puppet
cassandra::java::runtimeoption { 'prof': }
```

##### factory generated

```puppet
cassandra::java:
  runtime_options:
    check: jni
    prof:
```

#### Parameters

The following parameters are available in the `cassandra::java::runtimeoption` defined type.

##### `value`

Data type: `Optional[String]`

value to be added to the runtime option

Default value: `undef`

## Data types

### Cassandra::Rackdc

Hash allowing to setup the content of `cassandra-rackdc.properties`.
Note, that the fields `dc` and `rack` mandatory to setup rackdc, while
`dc_suffix` and `prefer_local` can be set optionally.

Alias of `Struct[{
  dc           => String,
  rack         => String,
  dc_suffix    => Optional[String],
  prefer_local => Optional[Boolean],
}]`

### Cassandra::Service::Enable

Service enable can be `manual` or `mask` besides the Boolean.

Alias of `Variant[Boolean, Enum['manual','mask']]`

### Cassandra::Service::Ensure

This type is simply missing from Stdlib.

Alias of `Optional[Variant[Boolean,Enum['stopped', 'running']]]`
