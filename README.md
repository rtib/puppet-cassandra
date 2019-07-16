
# Cassandra

A Puppet module to run Cassandra nodes.

#### Table of Contents

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Cassandra](#Cassandra)
      - [Table of Contents](#Table-of-Contents)
  - [Description](#Description)
  - [Setup](#Setup)
    - [What cassandra affects](#What-cassandra-affects)
    - [Setup Requirements](#Setup-Requirements)
  - [Usage](#Usage)
    - [Configuration](#Configuration)
      - [Main node configuration](#Main-node-configuration)
    - [Rack and DC settings](#Rack-and-DC-settings)
    - [Topology settings](#Topology-settings)
  - [Reference](#Reference)
  - [Limitations](#Limitations)
  - [Development](#Development)
  - [Release Notes/Contributors/Etc. **Optional**](#Release-NotesContributorsEtc-Optional)

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

### Configuration

#### Main node configuration

The module provides you access to the main configuration file, the `cassandra.yaml`, though the configuration parameter `config`. This can contain a hash resembling the structure of the `cassandra.yaml`, which will be merged to the current content of the `cassandra.yaml` file on the node itself. This merge will only happen on the node itself.

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

### Rack and DC settings

When using `GossipingPropertyFileSnitch` class for snitching your cluster, you need to setup the `cassandra-rackdc.properties` file. This can be done through the `rackdc` parameter of this module.

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

When using `PropertyFileSnitch` of `GossipingPropertyFileSnitch` classes on you setup, you might want to control the contents of `cassandra-topology.properties` file. This is done through the `topology` parameter of this module. This may contain a multi-leveld hash mapping your datacenters to your racks and your racks to the array of your nodes.

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

Note, that if you leave the `topology` undef, the module will remove the `cassandra-topology.properties` file from your nodes. This is intended to support the migration from `PropertyFileSnitch` to `GossipingPropertyFileSnitch`.

Note, that the module will not notify the service on updates on the `cassandra-topology.properties` file, as both snitch classes using it are able to on-the-fly reload the file.

## Reference

This section is deprecated. Instead, add reference information to your code as Puppet Strings comments, and then use Strings to generate a REFERENCE.md in your module. For details on how to add code comments and generate documentation with Strings, see the Puppet Strings [documentation](https://puppet.com/docs/puppet/latest/puppet_strings.html) and [style guide](https://puppet.com/docs/puppet/latest/puppet_strings_style.html)

If you aren't ready to use Strings yet, manually create a REFERENCE.md in the root of your module directory and list out each of your module's classes, defined types, facts, functions, Puppet tasks, task plans, and resource types and providers, along with the parameters for each.

For each element (class, defined type, function, and so on), list:

  * The data type, if applicable.
  * A description of what the element does.
  * Valid values, if the data type doesn't make it obvious.
  * Default value, if any.

For example:

```
### `pet::cat`

#### Parameters

##### `meow`

Enables vocalization in your cat. Valid options: 'string'.

Default: 'medium-loud'.
```

## Limitations

In the Limitations section, list any incompatibilities, known issues, or other warnings.

## Development

In the Development section, tell other users the ground rules for contributing to your project and how they should submit their work.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You can also add any additional sections you feel are necessary or important to include here. Please use the `## ` header.
