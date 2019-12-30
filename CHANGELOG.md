# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [1.0.0]
v1.0.0 is a backwards-incompatible release. Please see the [upgrading guide](./docs/upgrading_to_v2.0.md).

### Changed

- Supported version of Terraform is 0.12. [#7]
- Used new project structure and testing approach. [#18]
- Deprecated Variable `credentials_file_path`. [#4]
- Renamed variable `project_name` to `project_id`

### Added

- Added submodule `create-secret`. [#9]
- Added submodule `create-secrets` [#9]
- Used `for_each` instead of `count` for buckets iteration. [#8]
- Added variable `project_id` to application-specific bucket name to ensure it's original.
- Rewritten all test to check created resources not only terraform outputs.


### Fixed

- Fixed bug with shared bucket name mismatching. [#20]

## [v0.1.0]
### Added
- Initial module release

