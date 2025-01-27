# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.4] - 2024-12-05
### Fixed
- Set default weight to one for Envialia shipping labels.

## [0.3.3] - 2024-03-22
### Fixed
- Prefix delivery location with country code in Mondial Relay Dual.

## [0.3.2] - 2023-09-14
### Fixed
- Add follow_redirect to MondialRelay module API call

## [0.3.1] - 2023-01-13
### Fixed
- Inpost week hours

## [0.3.0] - 2021-11-26
### Added
- Envialia courier integration

## [0.2.1] - 2021-11-04
### Fixed
- Field `clienteRecogida` must have the same value as `codDest` in Correos Express pickup.

## [0.2.0] - 2021-11-03
### Added
- `Address` can now include a custom id for couriers that support it (currently only Correos Express).

## [0.1.1] - 2021-10-11
### Fixed
- Fix keyword parameter passing to make it compatible with Ruby 3.0.

## [0.1.0] - 2021-09-27
🎉 First release!

[Unreleased]: https://github.com/ecommerce-ventures/deliveries/compare/v0.3.4...HEAD
[0.3.4]: https://github.com/ecommerce-ventures/deliveries/compare/v0.3.3...v0.3.4
[0.3.3]: https://github.com/ecommerce-ventures/deliveries/compare/v0.3.2...v0.3.3
[0.3.2]: https://github.com/ecommerce-ventures/deliveries/compare/v0.3.1...v0.3.2
[0.3.1]: https://github.com/ecommerce-ventures/deliveries/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/ecommerce-ventures/deliveries/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/ecommerce-ventures/deliveries/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/ecommerce-ventures/deliveries/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/ecommerce-ventures/deliveries/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/ecommerce-ventures/deliveries/releases/tag/v0.1.0
