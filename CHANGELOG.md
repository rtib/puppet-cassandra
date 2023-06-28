<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v5.0.2](https://github.com/rtib/puppet-cassandra/tree/v5.0.2) - 2023-06-28

[Full Changelog](https://github.com/rtib/puppet-cassandra/compare/v5.0.1...v5.0.2)

### Fixed

- adopt stdlib-9 [#39](https://github.com/rtib/puppet-cassandra/pull/39) ([rtib](https://github.com/rtib))
- [MODULES-11117] enforce documentation template conformance to meet requirements [#37](https://github.com/rtib/puppet-cassandra/pull/37) ([rtib](https://github.com/rtib))
- update stdlib dependency version limit [#35](https://github.com/rtib/puppet-cassandra/pull/35) ([rtib](https://github.com/rtib))

## [v5.0.1](https://github.com/rtib/puppet-cassandra/tree/v5.0.1) - 2021-08-05

[Full Changelog](https://github.com/rtib/puppet-cassandra/compare/v5.0.0...v5.0.1)

### Fixed

- remove disclaimer on Cassandra 4 feature [#34](https://github.com/rtib/puppet-cassandra/pull/34) ([rtib](https://github.com/rtib))

## [v5.0.0](https://github.com/rtib/puppet-cassandra/tree/v5.0.0) - 2021-06-28

[Full Changelog](https://github.com/rtib/puppet-cassandra/compare/v4.0.0...v5.0.0)

### Changed
- review requirement and dependencies, version cut [#32](https://github.com/rtib/puppet-cassandra/pull/32) ([rtib](https://github.com/rtib))
- change default value service enable [#31](https://github.com/rtib/puppet-cassandra/pull/31) ([rtib](https://github.com/rtib))

## [v4.0.0](https://github.com/rtib/puppet-cassandra/tree/v4.0.0) - 2021-05-28

[Full Changelog](https://github.com/rtib/puppet-cassandra/compare/v3.1.0...v4.0.0)

### Changed
- dynamic test matrix, update os support [#30](https://github.com/rtib/puppet-cassandra/pull/30) ([rtib](https://github.com/rtib))

## [v3.1.0](https://github.com/rtib/puppet-cassandra/tree/v3.1.0) - 2021-03-03

[Full Changelog](https://github.com/rtib/puppet-cassandra/compare/v3.0.0...v3.1.0)

### Added

- Add management of reaper [#24](https://github.com/rtib/puppet-cassandra/pull/24) ([rtib](https://github.com/rtib))

### Fixed

- Upgrade module dependencies [#25](https://github.com/rtib/puppet-cassandra/pull/25) ([rtib](https://github.com/rtib))

## [v3.0.0](https://github.com/rtib/puppet-cassandra/tree/v3.0.0) - 2021-03-02

[Full Changelog](https://github.com/rtib/puppet-cassandra/compare/v2.3.0...v3.0.0)

### Changed
- Drop support for Puppet 5 [#20](https://github.com/rtib/puppet-cassandra/pull/20) ([rtib](https://github.com/rtib))

### Fixed

- Migrate CI/CD to GHA [#21](https://github.com/rtib/puppet-cassandra/pull/21) ([rtib](https://github.com/rtib))

## [v2.3.0](https://github.com/rtib/puppet-cassandra/tree/v2.3.0) - 2020-07-20

[Full Changelog](https://github.com/rtib/puppet-cassandra/compare/v2.2.1...v2.3.0)

### Added

- add sizeoptions parameter to jvm_option_set [#16](https://github.com/rtib/puppet-cassandra/pull/16) ([rtib](https://github.com/rtib))

### Fixed

- raise loglevel of deprecation message to warning [#17](https://github.com/rtib/puppet-cassandra/pull/17) ([rtib](https://github.com/rtib))

## [v2.2.1](https://github.com/rtib/puppet-cassandra/tree/v2.2.1) - 2020-07-14

[Full Changelog](https://github.com/rtib/puppet-cassandra/compare/v2.2.0...v2.2.1)

### Fixed

- parameter names fixed in docs [#14](https://github.com/rtib/puppet-cassandra/pull/14) ([rtib](https://github.com/rtib))

## [v2.2.0](https://github.com/rtib/puppet-cassandra/tree/v2.2.0) - 2020-07-13

[Full Changelog](https://github.com/rtib/puppet-cassandra/compare/v2.1.2...v2.2.0)

### Added

- Deprecate cassandra::java::gc [#12](https://github.com/rtib/puppet-cassandra/pull/12) ([rtib](https://github.com/rtib))
- New feature: JVM option sets [#11](https://github.com/rtib/puppet-cassandra/pull/11) ([rtib](https://github.com/rtib))

### Fixed

- Make type enforcement less restrictive [#13](https://github.com/rtib/puppet-cassandra/pull/13) ([rtib](https://github.com/rtib))

## [v2.1.2](https://github.com/rtib/puppet-cassandra/tree/v2.1.2) - 2020-02-07

[Full Changelog](https://github.com/rtib/puppet-cassandra/compare/v2.1.1...v2.1.2)

### Added

- Prepare for Cassandra 4 [#7](https://github.com/rtib/puppet-cassandra/pull/7) ([rtib](https://github.com/rtib))

## [v2.1.1](https://github.com/rtib/puppet-cassandra/tree/v2.1.1) - 2019-07-22

[Full Changelog](https://github.com/rtib/puppet-cassandra/compare/v2.1.0...v2.1.1)

### Fixed

- text improvements [#5](https://github.com/rtib/puppet-cassandra/pull/5) ([rtib](https://github.com/rtib))
- fix some latent syntax errors [#4](https://github.com/rtib/puppet-cassandra/pull/4) ([rtib](https://github.com/rtib))

## [v2.1.0](https://github.com/rtib/puppet-cassandra/tree/v2.1.0) - 2019-07-19

[Full Changelog](https://github.com/rtib/puppet-cassandra/compare/v2.0.1...v2.1.0)

### Added

- add feature to add initial_token by lookup [#2](https://github.com/rtib/puppet-cassandra/pull/2) ([rtib](https://github.com/rtib))

### Fixed

- text improvements [#3](https://github.com/rtib/puppet-cassandra/pull/3) ([rtib](https://github.com/rtib))

## [v2.0.1](https://github.com/rtib/puppet-cassandra/tree/v2.0.1) - 2019-07-18

[Full Changelog](https://github.com/rtib/puppet-cassandra/compare/f5bd00f593220c01e4b87d2d6f76e393075b8e65...v2.0.1)
