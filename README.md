
# Cassandra

A Puppet module to run Cassandra nodes.

# Project state

GitHub: [![GitHub issues](https://img.shields.io/github/issues/rtib/puppet-cassandra.svg)](https://github.com/rtib/puppet-cassandra/issues) [![GitHub license](https://img.shields.io/github/license/rtib/puppet-cassandra.svg)](https://github.com/rtib/puppet-cassandra) [![GitHub tag](https://img.shields.io/github/commit-activity/y/rtib/puppet-cassandra)](https://github.com/rtib/puppet-cassandra/releases) [![GitHub tag](https://img.shields.io/github/last-commit/rtib/puppet-cassandra)](https://github.com/rtib/puppet-cassandra/releases) [![GitHub tag](https://img.shields.io/github/tag/rtib/puppet-cassandra.svg)](https://github.com/rtib/puppet-cassandra/releases)

Workflows: [![CI](https://github.com/rtib/puppet-cassandra/actions/workflows/ci.yaml/badge.svg)](https://github.com/rtib/puppet-cassandra/actions/workflows/ci.yaml) [![release](https://github.com/rtib/puppet-cassandra/actions/workflows/release.yaml/badge.svg)](https://github.com/rtib/puppet-cassandra/actions/workflows/release.yaml)

Puppet: [![PDK Version](https://img.shields.io/puppetforge/pdk-version/trepasi/cassandra.svg)](https://forge.puppet.com/trepasi/cassandra) [![Puppet Forge](https://img.shields.io/puppetforge/v/trepasi/cassandra.svg)](https://forge.puppet.com/trepasi/cassandra) [![Puppet Forge](https://img.shields.io/puppetforge/dt/trepasi/cassandra.svg)](https://forge.puppet.com/trepasi/cassandra)

# Table of Contents

<!-- code_chunk_output -->

- [Description](#description)
- [Integration test matrix](#integration-test-matrix)
- [Setup](#setup)
  - [What cassandra affects](#what-cassandra-affects)
  - [Setup Requirements](#setup-requirements)
- [Usage](#usage)
  - [Main node configuration](#main-node-configuration)
    - [Setting up initial_token](#setting-up-initial_token)
  - [Rack and DC settings](#rack-and-dc-settings)
  - [Topology settings](#topology-settings)
  - [Setting the runtime environment](#setting-the-runtime-environment)
    - [Environment variables](#environment-variables)
    - [JVM options](#jvm-options)
    - [Java runtime settings](#java-runtime-settings)
  - [Java garbage collection settings](#java-garbage-collection-settings)
  - [JVM option sets](#jvm-option-sets)
    - [Cassandra 3.x JVM options](#cassandra-3x-jvm-options)
    - [Cassandra 4.0 JVM setup](#cassandra-40-jvm-setup)
- [Reference](#reference)
- [Development](#development)

<!-- /code_chunk_output -->

## Description

This Puppet module is a spin-off of several years of experience we collected in running Cassandra in a production environment, using Puppet to maintain the configuration of the nodes. During its evolution the module has proven to be useful for Cassandra versions ranging from early 1.1, over many 2.x, 3.0, 3.11 to latest 4.0 releases and multiple distributions, e.g. DSE, Apache and other. The main distinction feature is that this module does not incorporate templating of the main configuration file and no version switches.

Conceptualized to fit into a roles/profiles design pattern, this module keeps a strong focus on the topic of Cassandra node configuration disregarding many aspects bound to the use-case and the infrastructure environment.

## Integration test matrix

The module undergoes automated acceptance test, assessing its capability of deploying a Cassandra node of all supported version branches on multiple OS distribution and JDK conbinations. The table below is summerizing this test matrix.

| Cassandra branch | OS distro | JDK[<sup>1</sup>](#java) |
|---|---|---|
| 2.1 | Debian:9<br>Ubuntu:18.04 | OpenJDK-8 |
| 2.2 | Debian:9<br>Ubuntu:18.04 | OpenJDK-8 |
| 3.0 | Debian:9<br>Ubuntu:16.04<br>Ubuntu:18.04 | OpenJDK-8 |
| 3.11 | Debian:9<br>Ubuntu:16.04<br>Ubuntu:18.04 | OpenJDK-8 |
| 4.0 | Debian:9<br>Debian:10<br>Ubuntu:16.04<br>Ubuntu:18.04 | OpenJDK-8<br>OpenJDK-11<br>OpenJDK-8<br>OpenJDK-8<br> |

<a class="anchor" id="java">1</a>: Note, that this module will not manage any JDK installation. The JDK versions listed here are automatically installed via dependencies while the module is installing the latest available Cassandra version from the release branch.

## Setup

### What cassandra affects

This module affects the following component:

- Install the Packages ``cassandra`` and ``cassandra-tools``.
- It takes control over the file ``.cassandra.in.sh`` located in Cassandra user's home directory.
- It takes control over ``cassandra-rackdc.properties`` and ``cassandra-topology.properties``
- Optionally it can take control over the ``jvm.options`` file, used to configure Java GC parameter.
- It manages the content of the ``cassandra.yaml`` by merging a configuration hash to the file as it is found on the node, i.e. installed from the package.

A bit more important to know is that it does not control the contents of ``cassandra-env.sh`` and many other files, which might lead to conflicts during package updates.

### Setup Requirements

To use this module it is required, that your nodes have package repository setup in place which enables the installation of the Cassandra packages using the regular package manager of your operating system and the runtime environment for operating Cassandra, i.e. Kernel settings, NTP setup, Java JDK installation, firewall settings, etc. are already in place. All these can be setup in your profile and role modules.

For operating Cassandra it will be necessary to orchestrate diverse operations over the cluster. Puppet is not intended to do that, thus these requirements have to be fulfilled with other tools.

## Usage

As soon you have fulfilled the above prerequisites to run Cassandra on your nodes, this module can install an run your cluster.

Include the module to your node manifests (or your role or profile module):

```puppet
include cassandra
```

This will install the latest available version of packages `cassandra` and `cassandra-tools` and ensure they stay installed. The default settings will prevent autoatic upgrading.

If you want Puppet to install a specific version, e.g. 3.0.18, just add the following parameter to your Hiera DB:

```yaml
cassandra::cassandra_ensure: 4.0.0
```

The version ensurement of the tools package defaults to `cassandra::cassandra_ensure` but can be set differently by defining:

```yaml
cassandra::tools_ensure: latest
```

If you don't want to install the tools package, you can set:

```yaml
cassandra::tools_ensure: absent
```

In the case, your package name is differs from default Apache release, you may use `cassandra_package` and/or `tools_package` to set the name, e.g.

```yaml
cassandra::cassandra_package: dsc22
```

### Main node configuration

The module provides you access to the main configuration file, the `cassandra.yaml`, through the configuration parameter `config`. This may contain a hash resembling the structure of the `cassandra.yaml`, which will be merged to the current content of the `cassandra.yaml` file on the node. This merge will only happen on the node itself.

Thus the `config` parameter should contain only those settings you want to have non-default, i.e. want to change on the node. Keep in mind, that the structure of this hash must fit to the structure of `cassandra.yaml`, e.g.

```yaml
cassandra::config:
  cluster_name: Example Cassandra cluster
  endpoint_snitch: PropertyFileSnitch
  seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
      parameters:
        - seeds: 10.0.0.1,10.0.1.1
  listen_address: "%{facts.networking.ip}"
```

As seen for `listen_address` in the example, you can use Hiera interpolation to access Facts to setup the Cassandra node.

For deeper understanding of this merge procedure refer to the [cataphract/yaml_settings](https://forge.puppet.com/cataphract/yaml_settings) module, which is used to merge the `config` hash with the `cassandra.yaml` on the node.

#### Setting up initial_token

Under some circumstances it is necessary to setup the `initial_token` within `cassandra.yaml`. While this needs to be a unique value for each node and you probably don't want to create per-node hiera files just for a single value, the module is providing a workaround. You can set the `initial_tokens` parameter which may contain a hash mapping the initial token for each node by a node key. As soon the parameter is set, the module will lookup the initial_token for each node by the configured `node_key`, which defaults to the FQDN of the node and set the `initial_token` within the config hash to that value. If there is no entry for a node found, an error is raised which stops the Puppet agent. Example:

```yaml
cassandra::initial_tokens:
  node01.server.lan: '0'
  node02.server.lan: '56713727820156410577229101238628035242'
  node03.server.lan: '113427455640312821154458202477256070484'
```

The `node_key` parameter, which defaults to `$facts['networking']['fqdn']` can be changed if you want to map the initial_token by some other ID.

### Rack and DC settings

When using `GossipingPropertyFileSnitch` class for endpoint snitch your cluster, you need to setup the `cassandra-rackdc.properties` file. This is done through the `rackdc` parameter of this module.

```yaml
cassandra::rackdc:
  dc: dc1
  rack: rackA
```

You can optionally add the `prefer_local` and `dc_suffix` parameter to the `rackdc` hash.

### Topology settings

When you set the enpoint snitch using `PropertyFileSnitch` or `GossipingPropertyFileSnitch` classes, you might want to control the contents of `cassandra-topology.properties` file. This is done through the `topology` parameter of this module. This contains a multi-leveld hash mapping arrays of your nodes to the racks and the racks to the datacenters.

```yaml
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

This will end up in a `cassandra-topology.properties` file containing:

```properties
10.0.0.1=dc1:rackA
10.0.0.2=dc1:rackA
10.0.0.3=dc1:rackB
10.0.0.4=dc1:rackB
10.0.1.1=dc2:rackA
10.0.1.2=dc2:rackA
10.0.1.3=dc2:rackB
10.0.1.4=dc2:rackB
```

Note, that if you leave the `topology` parameter `undef` (which is the default), the module will remove the `cassandra-topology.properties` file from your nodes. This is intended to support the migration from `PropertyFileSnitch` to `GossipingPropertyFileSnitch`.

Note, that the module will not notify the service on updates to the `cassandra-topology.properties` file, as both snitch classes using this file are able to reload it in runtime. All other configuration changes will notify the service.

### Setting the runtime environment

The module provides a variety of settings to the runtime environment and various settings to the Java VM.

#### Environment variables

The defined type `cassandra::environment::variable` can be used to created variable in the Cassandra process's environment. These typically contain `MAX_HEAP_SIZE`, `HEAP_NEWSIZE`, `JAVA_HOME`, `LOCAL_JMX` and other.

You can also use the `environment` parameter of this module to create `cassandra::environment::variable` instances, e.g.:

```yaml
cassandra::environment:
  MAX_HEAP_SIZE: 8G
  HEAP_NEWSIZE: 2G
```

#### JVM options

The defined type `cassandra::environment::jvm_option` adds JVM options to the process running Cassandra.

You can also use the `jvm_options` parameter of this module to create instances of `cassandra::environment::jvm_option`, e.g.:

```yaml
cassandra::jvm_options:
  - verbose:gc
  - server
```

#### Java runtime settings

This module provides a variety of Java runtime settings. Within the `cassandra::java` namespace there are components allowing to setup:

- Java agents through defined type `cassandra::java::agent`
- Properties through defined type `cassandra::java::property`
- runtime options through defined type `cassandra::java::runtimeoption`
- advanced runtime options through defined type `cassandra::java::advancedruntimeoption`
- garbage collector settings through class `cassandra::java::gc`

You can use the `java` property to create instances of the above types and classes. E.g.:

```yaml
cassandra::java:
  properties:
    cassandra.consistent.rangemovement: false
    cassandra.replace_address: 10.0.0.2
  agents:
    jmx_prometheus_javaagent.jar: 8080:config.yaml
  runtime_options:
    check: jni
  adv_runtime_options:
    LargePageSizeInBytes: 2m
    UseLargePages: true
    AlwaysPreTouch: true
```

### Java garbage collection settings

__Deprication notice:__ `cassandra::java_gc` and the class `cassandra::java::gc` are now deprecated. Consider using JVM option sets instead.

Settings to Java garbage collector can be made by instanciating the `cassandra::java::gc` class. This can be done via the `java_gc` parameter of this module. E.g.:

```yaml
cassandra::java_gc:
  collector: g1
  params:
    maxGCPauseMillis: 300
```

### JVM option sets

Since version 2.2 this module is supporting a novel approach to set JVM options for the Cassandra runtime. This is provided by the JVM option set feature, which is controlling the `jvm.options` file of Cassandra 3.x and many combinations used by Cassandra 4.0 and later.

Note, that much of the settings here will override settings done with `cassandra::java` and all of this will collide with `cassandra::java_gc` if set. Thus remove `cassandra::java_gc` at all when starting with `cassandra::jvm_option_sets` and consider migrating settings within `cassandra::java`, `cassandra::jvm_options` and most of `cassandra::environment` (i.e. heap setting) to JVM option sets.

#### Cassandra 3.x JVM options

The default behaviour will control the `jvm.options` file of Cassandra 3.x installations. The defined type `cassandra::jvm_option_set` resource takes parameters `options`, `sizeoptions`, `properties` and `advancedoptions` and add the settings to the `jvm.options` file.

The main class is taking the parameter `cassandra::jvm_option_sets` to build instances of `cassandra::jvm_option_set` type. This also enables to pass the option sets via hiera to the module.

```yaml
cassandra::jvm_option_sets:
  example:
    options:
      - ea
      - server
    sizeoptions:
      Xms: 4G
      Xmx: 4G
      Xmn: 800M
    advancedoptions:
      LargePageSizeInBytes: 2m
      UseLargePages: true
      AlwaysPreTouch: true
    properties:
      cassandra.start_rpc: false
```

For all options, advanced runtime options and properties in the above example Puppet will take control over the according line in the `jvm.options` file and set the desired option. The top level ID (`example` in this case) is the name of the option set allowing the grouping of options. Many option sets are allowed, however, it is not allowed to set the same option within different option sets.

Note, that many other settings may be contained in the `jvm.options` file, which are not touched by Puppet.

In order to enable the removal of specific settings from the `jvm.options` file use a tilde `~` to prefix options, and undef value (denoted with tilede `~` in Hiera) of `properties`, `sizeoptions` and `advancedoptions`. The example below show how to remove specific options, advancedruntimeoptions and properties.

```yaml
cassandra::jvm_option_sets:
  remove:
    options:
      - ~ea
    sizeoptions:
      Xmn: ~
    advancedoptions:
      FlightRecorder: ~
    properties:
      cassandra.initial_token: ~
```

#### Cassandra 4.0 JVM setup

Cassandra 4.0 and later is using distinct options files for server operation and client tools, for Java version independent options and for Java-8 or Java-11 respectively. Set the parameters `optsfile` to `jvm`, `jvm8` or `jvm11` and `variant` to `server` or `clients` accordingly.

```yaml
cassandra::jvm_option_sets:
  java8example:
    optsfile: jvm8
    variant: server
    advancedoptions:
      ThreadPriorityPolicy: 42
  java11example:
    optsfile: jvm11
    variant: server
    advancedoptions:
      UseConcMarkSweepGC: false
      CMSParallelRemarkEnabled: ~
      UnlockExperimentalVMOptions: true
      UseZGC: true
```

## Reference

This module contains automatically generated reference documentation that can be found at [https://rtib.github.io/puppet-cassandra/](https://rtib.github.io/puppet-cassandra/) or within the REFERNCE.md file.

## Development

According to the license, you are free to contribute changes to this module. You may aware of the general workflows when contributing to GitHub projects, if not yet, please read CONTRIBUTING.md.
