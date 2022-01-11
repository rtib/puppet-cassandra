# cassandra

## Project status

GitHub: [![GitHub issues](https://img.shields.io/github/issues/rtib/puppet-cassandra.svg)](https://github.com/rtib/puppet-cassandra/issues) [![GitHub tag](https://img.shields.io/github/commit-activity/y/rtib/puppet-cassandra)](https://github.com/rtib/puppet-cassandra/releases) [![GitHub tag](https://img.shields.io/github/last-commit/rtib/puppet-cassandra)](https://github.com/rtib/puppet-cassandra/releases)

Nightly Workflows: [![CI](https://github.com/rtib/puppet-cassandra/actions/workflows/ci.yaml/badge.svg)](https://github.com/rtib/puppet-cassandra/actions/workflows/ci.yaml)

Puppet Forge:  ![PDK](https://img.shields.io/puppetforge/pdk-version/trepasi/cassandra.svg) [![release](https://github.com/rtib/puppet-cassandra/actions/workflows/release.yaml/badge.svg)](https://github.com/rtib/puppet-cassandra/actions/workflows/release.yaml) [![Puppet Forge](https://img.shields.io/puppetforge/v/trepasi/cassandra.svg)](https://forge.puppet.com/trepasi/cassandra)

## Table of Contents


<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=3 orderedList=false} -->

<!-- code_chunk_output -->

- [Project status](#project-status)
- [Table of Contents](#table-of-contents)
- [Description](#description)
- [Setup](#setup)
  - [What cassandra affects](#what-cassandra-affects)
  - [Setup Requirements](#setup-requirements)
  - [Beginning with cassandra](#beginning-with-cassandra)
- [Usage](#usage)
  - [Installation versions](#installation-versions)
  - [Main node configuration](#main-node-configuration)
  - [Rack and DC settings](#rack-and-dc-settings)
  - [Topology settings](#topology-settings)
  - [Setting the runtime environment](#setting-the-runtime-environment)
  - [Java garbage collection settings](#java-garbage-collection-settings)
  - [JVM option sets](#jvm-option-sets)
- [Reference](#reference)
- [Limitations](#limitations)
- [Development](#development)

<!-- /code_chunk_output -->

## Description

This module enables Puppet to install, configure and run [Apache Cassandra][1] nodes. As a spin-off of several years of experience we collected in running Cassandra in a production environment, using Puppet to maintain the configuration of the nodes. During its evolution the module has proven to be useful for Cassandra versions ranging from early 1.1, over many 2.x, 3.0, 3.11 to latest 4.0 releases and multiple distributions, e.g. DSE, Apache and other.

Leveraging the declarative nature of Puppet DSL, Cassandra configuration is considered a declarative description of the desired state and will be ensured in the node configuration. Configuration values not declared in the manifest will be kept untouched by this module.

Conceptualized to fit into a roles/profiles design pattern, this module keeps a strong focus on the topic of Cassandra node configuration disregarding many aspects bound to the use-case and the infrastructure environment.

## Setup

### What cassandra affects

This module affects the following component:

* Install the Packages ``cassandra`` and ``cassandra-tools``.
* It takes control over the file ``.cassandra.in.sh`` located in Cassandra user's home directory.
* It takes control over ``cassandra-rackdc.properties`` and ``cassandra-topology.properties``
* Optionally it can take control over the ``jvm.options`` file and its successors for multiple Java versions and variants, used to configure Java parameters.
* It manages the content of the ``cassandra.yaml`` by merging a configuration hash to the file as it is found on the node, i.e. installed from the package.

A bit more important to know is that it does not control the contents of ``cassandra-env.sh`` and many other files, which might lead to conflicts during package updates.

### Setup Requirements

Installation and running of Cassandra will require some other settings not covered by this module, e.g.:

* access to a package repository providing the necessery packages for your operating system distribution
* installation of a suitable Java runtime environment
* setup of a proper clock synchronisation, e.g. NTP
* configuration of additional settings, e.g. kernel parameter, firewall, etc.

### Beginning with cassandra

Include the module to your node manifests (or your role or profile module):

```puppet
contain cassandra
```

## Usage

Once included in the node manifest the module can be configured via Hiera.

### Installation versions

By default the latest available version of  `cassandra` and `cassandra-tools` packages will be installed. The default settings will prevent autoatic upgrades.

If you want Puppet to install a specific version, e.g. 4.0.0, just add the following parameter to your Hiera DB:

```yaml
cassandra::cassandra_ensure: 4.0.0
```

The version ensurement of the tools package defaults to `cassandra::cassandra_ensure` but can be set differently, e.g.:

```yaml
cassandra::tools_ensure: latest
```

If you don't want to install the tools package, you can set:

```yaml
cassandra::tools_ensure: absent
```

In the case, your package name differs from default Apache releases you may change `cassandra_package` and/or `tools_package` settings, e.g.

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

If your Cassandra setup relies on the setting of `initial_token` within `cassandra.yaml`, the module is providing a sophisticated feature. You may set the `initial_tokens` parameter containing a hash mapping the initial token for each node by a node key. The module will lookup the initial_token for each node by the configured `node_key` and set the `initial_token` within the config hash. If there is no entry for a node found, an error is raised which stops the Puppet agent on that node. Example:

```yaml
cassandra::initial_tokens:
  node01.server.lan: '0'
  node02.server.lan: '56713727820156410577229101238628035242'
  node03.server.lan: '113427455640312821154458202477256070484'
```

The `node_key` parameter, which defaults to `$facts['networking']['fqdn']` can be changed if you want to map the initial_token by some other ID.

### Rack and DC settings

When using `GossipingPropertyFileSnitch` class for endpoint snitch your cluster, you can manage the `cassandra-rackdc.properties` file through the `rackdc` parameter of this module.

```yaml
cassandra::rackdc:
  dc: dc1
  rack: rackA
```

Optionally parameters `prefer_local` and `dc_suffix` are also accepted in the `rackdc` hash.

### Topology settings

Using enpoint snitch classes `PropertyFileSnitch` or `GossipingPropertyFileSnitch`, you might want to control the contents of `cassandra-topology.properties` file. This is enabled through the `topology` parameter of this module. Containing a multi-leveld hash mapping arrays of your nodes to the racks and the racks to the datacenters. For example:

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

Note #1: leaving the `topology` parameter `undef` (which is default), the module will remove the `cassandra-topology.properties` file from your nodes. This is intended behaviour to support the migration from `PropertyFileSnitch` to `GossipingPropertyFileSnitch`.

Note #2: while many configuration changes will notify the service to restart, this is suppressed in the module on updates to the `cassandra-topology.properties` file. Changes made to the topology won't bump the Cassandra node, because both snitch classes using this file are reloading it in runtime to read its updated content.

### Setting the runtime environment

The module provides a variety of settings to runtime environment and the Java VM.

#### Environment variables

The defined type `cassandra::environment::variable` can be used to created variables in the Cassandra process's environment. These typically contain `MAX_HEAP_SIZE`, `HEAP_NEWSIZE`, `JAVA_HOME`, `LOCAL_JMX` and other Cassandra specific variables.

Using the `environment` parameter will create `cassandra::environment::variable` instances, e.g.:

```yaml
cassandra::environment:
  MAX_HEAP_SIZE: 8G
  HEAP_NEWSIZE: 2G
```

#### JVM options

The defined type `cassandra::environment::jvm_option` add options to the JVM Cassandra is running on.

Using the `jvm_options` parameter will create instances of `cassandra::environment::jvm_option`, e.g.:

```yaml
cassandra::jvm_options:
  - verbose:gc
  - server
```

#### Java runtime settings

Within the `cassandra::java` namespace there are components allowing to setup:

* Java agents through defined type `cassandra::java::agent`
* Properties through defined type `cassandra::java::property`
* runtime options through defined type `cassandra::java::runtimeoption`
* advanced runtime options through defined type `cassandra::java::advancedruntimeoption`
* garbage collector settings through class `cassandra::java::gc`

Using the `java` property will create instances of the above. E.g.:

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

Settings to Java garbage collector can be made by instanciating the `cassandra::java::gc` class. Using the `java_gc` parameter will instantiate the class, e.g.:

```yaml
cassandra::java_gc:
  collector: g1
  params:
    maxGCPauseMillis: 300
```

### JVM option sets

Since version 2.2 the module is supporting a novel approach to setup options of Cassandra Java runtime. The JVM option set feature is controlling the `jvm.options` file of Cassandra 3.x and many combinations used for different Java versions and use case scopes by Cassandra 4.0 and later.

__Note__, that much of these settings will override settings done with `cassandra::java` and all of this will collide with `cassandra::java_gc` if set. Thus remove `cassandra::java_gc` at all when starting with `cassandra::jvm_option_sets` and consider migrating `cassandra::java` settings to `cassandra::jvm_options`.

#### JVM options for Cassandra 3.x

Default behaviour will control the `jvm.options` file. The defined type `cassandra::jvm_option_set` resource take parameters `options`, `sizeoptions`, `properties` and `advancedoptions` and add the settings to the `jvm.options` file.

Use the `cassandra::jvm_option_sets` parameter to build instances of `cassandra::jvm_option_set` type. For example:

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

For all options, advanced runtime options and properties in the above example, the Puppet module will take control over the according lines in the `jvm.options` file only and set the desired options. Many other settings within `jvm.options` will not be touched by Puppet.

The top level ID (`example`) is the name of the option set allowing the grouping of options. Multiple option sets are allowed, however, it is not allowed to set the same option within different option sets.

In order to enable the removal of specific settings from `jvm.options`, use a tilde `~` to prefix options, and undef value (denoted with tilde `~` in Hiera) of `properties`, `sizeoptions` and `advancedoptions`. The example below show how to remove specific settings.

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

Cassandra 4.0 and later is using distinct option files for server operation and client tools, for Java version independent options and for different Java versions. Set the parameters `optsfile` to `jvm`, `jvm8` or `jvm11` and `variant` to `server` or `clients` accordingly.

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

Automatically generated reference documentation is available in the [REFERENCE.md][2] file or at [https://rtib.github.io/puppet-cassandra/][3].

## Limitations

For supported operating systems and dependencies, see [metadata.json](https://github.com/rtib/puppet-cassandra/blob/main/metadata.json).

Extensive itegration tests are run nightly to assure quality  and compatibility with next releases.

The current integration test matrix:

| Cassandra branch | OS distro | JDK[<sup>1</sup>](#java) |
|---|---|---|
| 3.0 | Debian:9<br>Ubuntu:16.04<br>Ubuntu:18.04 | OpenJDK-8 |
| 3.11 | Debian:9<br>Ubuntu:16.04<br>Ubuntu:18.04 | OpenJDK-8 |
| 4.0 | Debian:9<br>Debian:10<br>Ubuntu:16.04<br>Ubuntu:18.04 | OpenJDK-8<br>OpenJDK-11<br>OpenJDK-8<br>OpenJDK-8<br> |

<a class="anchor" id="java">1</a>: Note, that this module will not manage any JDK installation. The JDK versions listed here are automatically installed via dependencies while the module is installing the latest available Cassandra version from the release branch.

## Development

The module is developed using recent [Puppet Development Kit][4], [validated][5] and extensively tested using [Puppet Litmus][6]. Automated workflows, implemented with [GitHub Actions][7] are run on demand and nightly, doing validation, spec tests and continuous integration tests.

As an open project, you are welcome to contribute to this module. Currently, there is no contribution guide specific to this module, general information about the workflow may apply. In case of questions feel free to open a issue or join community Slack channels #forge-modules, #puppet, #puppet-dev, #testing on slack.puppet.com.

Issues and pull requests will be addressed in a timely manner, according to community best practice. Releases are going to be published on demand, after having merged an set of sufficiently important changes and all tests succeeded. There may be automated rule enforcement in place to provide a healthy issue lifecycle.

[1]: https://cassandra.apache.org/
[2]: https://forge.puppet.com/modules/trepasi/cassandra/reference
[3]: https://rtib.github.io/puppet-cassandra/
[4]: https://puppet.com/docs/pdk/2.x/pdk.html
[5]: https://puppet.com/docs/pdk/1.x/pdk_testing.html
[6]: https://github.com/puppetlabs/puppet_litmus
[7]: https://docs.github.com/en/actions
