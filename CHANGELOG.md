# Changelog

All notable changes to `PhxJsonRpc` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.7.0] - 2024-10-15

### Added

- [Jason](https://hex.pm/packages/jason) as a dependency

### Changed

- BREAKING CHANGE: Bump required elixir version to 1.13 (minimum OTP version is set to 24)
- Bump dialyxir to 1.4.4
- Bump ex_json_schema to 0.10.2
- Bump ex_coveralls to 0.18.3
- Bump credo to 1.7.8
- Bump ex_doc to 0.30.5

## [0.6.0] - 2023-08-30

### Changed

- BREAKING CHANGE: Minimum elixir version is set to `1.12`
- Bump ex_json_schema from 0.9.2 to 0.10.1
- Bump dialyxir from 1.3.0 to 1.4.0
- Bump ex_doc from 0.30.3 to 0.30.6
- Bump excoveralls from 0.16.1 to 0.17.1

## [0.5.0] - 2023-04-21

### Added

- BREAKING CHANGE: `Context` as a second parameter to controller methods

## [0.4.0] - 2023-04-20

### Added

- Middleware interface and macro (handles requests before dispatching to the rpc controller)

### Changed

- `Router.handle` now accepts second optional parameter: `meta_data`
- Bump credo from 1.6.7 to 1.7.0
- Bump dialyxir from 1.2.0 to 1.3.0
- Bump excoveralls from 0.15.0 to 0.16.1
- Bump ex_doc from 0.29.0 to 0.29.4

## [0.3.8] - 2022-11-18

### Changed

- Bump ex_json_schema from 0.9.1 to 0.9.2
- Bump credo from 1.6.6 to 1.6.7
- Bump ex_doc from 0.28.4 to 0.29.0
- Bump excoveralls from 0.14.6 to 0.15.0

## [0.3.7] - 2022-08-21

### Changed

- Example controller moved to the `test` namespace
- Bump dialyxir from `1.1.0` to `1.2.0`
- Bump credo from `1.6.5` to `1.6.6`

## [0.3.6] - 2022-07-19

### Added

- Dialyzer support in `CI`
- Screenshots in `usage with phoenix` guide

### Changed

- Documentation structure in `README.md`

## [0.3.5] - 2022-07-18

### Changed

- Move assets to the test directory

## [0.3.4] - 2022-07-18

### Added

- Example to `howitworks` section in `README.md`
- Specified phoenix version in docs
- Matrix tests in `CI`
- [Dependabot](https://github.com/dependabot) support by [@sobolevn](https://github.com/sobolevn)
- Releases started for github repo

## [0.3.3] - 2022-07-07

### Changed

- Follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) standart

## [0.3.2] - 2022-07-06

### Added

- `excoveralls` for test coverage

### Fixed

- Test warnings, some doc typos

## [0.3.1] - 2022-07-05

### Fixed

- Documentation typo in `PhxJsonRpc.Router`
- Bug with `undefined` error in `PhxJsonRpc.Views.Helpers`

## [0.3.0] - 2022-07-04

### Added

- OTP configuration for the `PhxJsonRpc.Router`

## [0.2.2] - 2022-07-03

### Added

- `Request ID` to error log format in `PhxJsonRpc.Router.DefaultDispatcher`

## [0.2.1] - 2022-07-03

### Updated

- Improved documentation guide

### Added

- `howitworks` section to `README.md`

## [0.2.0] - 2022-07-03

### Added

- Maximum batch size limit property for `PhxJsonRpc.Router`

### Fixed

- Typespecs in `PhxJsonRpc.Router.Pipe` section

## [0.1.1] - 2022-07-03

### Added

- Link to `phoenix framework` in `README.md`

### Fixed

- Unneccessary condition, when accessing metadata in `PhxJsonRpc.Router.Pipe`
- Documentation in `PhxJsonRpc.Error` section

## [0.1.0] - 2022-07-03

### Added

- Initial commit
