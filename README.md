
# Cassandra

A Puppet module to run Cassandra nodes.

# Project state

GitHub: [![GitHub issues](https://img.shields.io/github/issues/rtib/puppet-cassandra.svg)](https://github.com/rtib/puppet-cassandra/issues) [![GitHub license](https://img.shields.io/github/license/rtib/puppet-cassandra.svg)](https://github.com/rtib/puppet-cassandra) [![GitHub tag](https://img.shields.io/github/tag/rtib/puppet-cassandra.svg)](https://github.com/rtib/puppet-cassandra/releases)

Travis-CI: [![Build Status](https://travis-ci.org/rtib/puppet-cassandra.svg?branch=master)](https://travis-ci.org/rtib/puppet-cassandra)

Puppet Forge: [![Puppet Forge](https://img.shields.io/puppetforge/v/trepasi/cassandra.svg)](https://forge.puppet.com/trepasi/cassandra) [![Puppet Forge](https://img.shields.io/puppetforge/f/trepasi/cassandra.svg)](https://forge.puppet.com/trepasi/cassandra) [![Puppet Forge](https://img.shields.io/puppetforge/dt/trepasi/cassandra.svg)](https://forge.puppet.com/trepasi/cassandra)

# Table of Contents

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Cassandra](#Cassandra)
- [Project state](#Project-state)
- [Table of Contents](#Table-of-Contents)
  - [Description](#Description)
  - [Setup](#Setup)
    - [What cassandra affects](#What-cassandra-affects)
    - [Setup Requirements](#Setup-Requirements)
  - [Usage](#Usage)
    - [Main node configuration](#Main-node-configuration)
      - [Setting up initial_token](#Setting-up-initialtoken)
    - [Rack and DC settings](#Rack-and-DC-settings)
    - [Topology settings](#Topology-settings)
    - [Environment settings](#Environment-settings)
      - [Environment variables](#Environment-variables)
      - [JVM options](#JVM-options)
      - [Java runtime settings](#Java-runtime-settings)
    - [Java garbage collection settings](#Java-garbage-collection-settings)
  - [Reference](#Reference)
  - [Development](#Development)

<!-- /code_chunk_output -->

## Description

This Puppet module is a spin-off of several years of experience we collected in running Cassandra in a production environment and using Puppet to maintain node configurations. During its evolution it has proven to be useful for Cassandra versions ranging from early 1.1, over many 2.x to latest 3.11 releases and multiple distributions, e.g. DSE, Apache and other. Its main distincion feature is that this module does not incorporate templating of the main configuration file, the `cassandra.yaml` at all and also no other version switches.

Conceptualized to fit into a roles/profiles design pattern, this module keeps a strong focus on the topic Cassandra node configuration disregarding many aspects bound to the use-case and/or the infrastructure environment.

## Setup

### What cassandra affects

This module affects the following component:

- Install the Packages ``cassandra`` and ``cassandra-tools``.
- It takes control over the file ``.cassandra.in.sh`` located in Cassandra user's home directory.
- It takes control over ``cassandra-rackdc.properties`` and ``cassandra-topology.properties``
- Optionally it can take control over the ``jvm.options`` file, used to configure Java GC parameter.
- It manages the content of the ``cassandra.yaml`` by merging a configuration hash to the file as it is found on the node, i.e. installed from the package.

A bit more important to know is that it does not control the contents of ``cassandra-env.sh`` and many other files, which might lead to conflicts durong package updates.

### Setup Requirements

To use this module it is required, that your nodes have package repository setup in place which enables the installation of the cassandra packages and the runtime environment for operating Cassandra, i.e. Kernel settings, NTP setup, Java JDK installation, firewall settings, etc. are already in place. All these can be setup in your profile and role modules.

For operating Cassandra it will be necessary to orchestrate diverse operations over the cluster. Puppet is not intended to do that, thus these requirements have to be fulfilled with other tools.

## Usage

As soon you have all presiquisites fulfilled to run Cassandra on your nodes, this module can install an run your cluster.

Include the module to your node manifests:

```puppet
include cassandra
```

This will install the latest available version of packages `cassandra` and `cassandra-tools` and ensure they stay installed. Upgrades are not automatically done.

If you want Puppet to install a specific version, set:

```yaml
cassandra::cassandra_ensure: 3.0.18
```

The version ensurement of the tools package defaults to `cassandra::cassandra_ensure` but can be set differently by defining:

```yaml
cassandra::tools_ensure: latest
```

If your don't want to install the tools package, you can:

```yaml
cassandra::tools_ensure: absent
```

In the case, your package name is other you may use `cassandra_package` and/or `tools_package` to set the name, e.g.

```yaml
cassandra::cassandra_package: dsc22
```

### Main node configuration

The module provides you access to the main configuration file, the `cassandra.yaml`, though the configuration parameter `config`. This can contain a hash resembling the structure of the `cassandra.yaml`, which will be merged to the current content of the `cassandra.yaml` file on the node. This merge will only happen on the node itself.

The `config` parameter should contain only those settings you want to have non-default, i.e. want to change on the node. Keep in mind, that the structure of this hash must fit to the structure of `cassandra.yaml`, e.g.

```yaml
cassandra::config:
  cluster_name: Example Cassandra cluster
  endpoint_snitch: PropertyFileSnitch
  seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
      parameters:
        - seeds: 10.0.0.1,10.0.1.1
  listen_address: %{facts.networking.ip}
```

As seen for `listen_address` in the example, you can use Hiera interpolation here to access Facts to setup the Cassandra node.

For deeper understanding of this merge procedure refer to the [cataphract/yaml_settings](https://forge.puppet.com/cataphract/yaml_settings) module, which is used to merge the `config` hash to the `cassandra.yaml` on the node.

#### Setting up initial_token

Under some circumstances it is necessary to setup the `initial_token` within `cassandra.yaml`. While this needs to be a unique value for each node and you probably don't want to create per-node hiera files just for a single value, the module is providing a workaround. You can set the `initial_tokens` parameter to contain a hash mapping the initial token for each node. As soon the parameter is set, the module will mangle the config hash by adding the `initial_token` with the value looked up from `inital_tokens`. Example:

```yaml
cassandra::initial_tokens:
  node01.server.lan: '0'
  node02.server.lan: '56713727820156410577229101238628035242'
  node03.server.lan: '113427455640312821154458202477256070484'
```

The lookup for the initial_token takes place by the key within the `node_key` parameter, which defaults to `$facts['networking']['fqdn']`. If you want to map the initial_token by some other ID, change the `node_key` param accordingly.

### Rack and DC settings

When using `GossipingPropertyFileSnitch` class on your cluster, you need to setup the `cassandra-rackdc.properties` file. This is done through the `rackdc` parameter of this module.

```yaml
cassandra::rackdc:
  dc: dc1
  rack: rackA
```

This will end up in a `cassandra-rackdc.properties` file containing:

```properties
dc=dc1
rack=rackA
```

You can optionally add the `prefer_local` and `dc_suffix` parameter to the `rackdc` hash.

### Topology settings

When using `PropertyFileSnitch` or `GossipingPropertyFileSnitch` classes on your setup, you might want to control the contents of `cassandra-topology.properties` file. This is done through the `topology` parameter of this module. This contains a multi-leveld hash mapping your datacenters to your racks and your racks to the array of nodes.

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

Note, that the module will, other than with config changes, not notify the service on updates the `cassandra-topology.properties` file is receiving, as both snitch classes using this file are able to on-the-fly reload it.

### Environment settings

The module provides a variety of settings to the runtime environment and  various JVM settings.

#### Environment variables

The defined type `cassandra::environment::variable` can be used to created env variable given to the Cassandra process. These typically contain such as `MAX_HEAP_SIZE`, `HEAP_NEWSIZE`, `JAVA_HOME`, `LOCAL_JMX` and other.

You can also use the `environment` parameter of this module to create `cassandra::environment::variable` instances, e.g.:

```yaml
cassandra::environment:
  MAX_HEAP_SIZE: 8G
  HEAP_NEWSIZE: 2G
```

#### JVM options

The defined type `cassandra::environment::jvm_option` adds JVM options to the process running Cassandra.

You can also use the `jvm_options` parameter of this module to create instances of `cassandra::environment::jvm_option`. E.g.:

```yaml
cassandra::jvm_options:
  - verbose:gc
  - server
```

#### Java runtime settings

This module provides a variety of Java runtime settings. Within the `cassandra::java` namespace there are components to allowing to setup:

- Java agents using the defined type `cassandra::java::agent`
- Properties using the defined type `cassandra::java::property`
- runtime options using the defined type `cassandra::java::runtimeoption`
- advanced runtime options using the defined type `cassandra::java::advancedruntimeoption`
- garbage collector settings using the class `cassandra::java::gc`

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

Settings to Java garbage collector can be made though `cassandra::java::gc` class. This can be instanciated via the `java_gc` parameter of this module. E.g.:

```yaml
cassandra::java_gc:
  collector: g1
  params:
    maxGCPauseMillis: 300
```

## Reference

This module contains automatically generated reference documentation that can be found at [https://rtib.github.io/puppet-cassandra/](https://rtib.github.io/puppet-cassandra/) or within the REFERNCE.md file.

## Development

According to the license, you are free to contribute changes to this module. You may aware of the general workflows when contributing to GitHub projects, if not yet, please read CONTRIBUTING.md.
