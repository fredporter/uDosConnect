# Public Structure Sweep

- generated: 2026-03-15-142335
- root: /Users/fredbook/Code
- binder: #binder/dev-public-structure-normalization

## uDOS-core

- class: contract-first
- expected roots: config contracts docs tests scripts schemas
- actual roots: .github binder compile config contracts docs memory plugins runtime schemas scripts tests udos_core vault
- missing recommended roots: none
- extra transitional roots: memory
- status: transitional

## uDOS-shell

- class: standard
- expected roots: config docs examples scripts src tests
- actual roots: .github cmd config dist docs examples internal node_modules scripts src tests
- missing recommended roots: none
- extra transitional roots: cmd dist internal node_modules
- status: transitional

## sonic-screwdriver

- class: packaging
- expected roots: docs scripts
- actual roots: .github apps build config core courses datasets distribution docs examples installers library memory modules payloads scripts services tests udos_sonic udos_sonic.egg-info ui vault wiki
- missing recommended roots: none
- extra transitional roots: udos_sonic udos_sonic.egg-info
- status: transitional

## uDOS-plugin-index

- class: contract-first
- expected roots: config contracts docs tests scripts schemas
- actual roots: .github config contracts docs examples schemas scripts tests
- missing recommended roots: none
- extra transitional roots: examples
- status: transitional

## uDOS-wizard

- class: service
- expected roots: config docs tests scripts services
- actual roots: .github apps config contracts docs examples mcp memory scripts services static tests wizard
- missing recommended roots: none
- extra transitional roots: apps contracts examples memory static
- status: transitional

## uDOS-gameplay

- class: standard
- expected roots: config docs examples scripts src tests
- actual roots: .github config docs examples scripts src tests
- missing recommended roots: none
- extra transitional roots: none
- status: aligned

## uHOME-empire

- class: standard
- expected roots: config docs examples scripts src tests
- actual roots: .github config docs examples scripts src tests
- missing recommended roots: none
- extra transitional roots: none
- status: aligned

## uHOME-matter

- class: standard
- expected roots: config docs examples scripts src tests
- actual roots: .github config docs examples scripts src tests
- missing recommended roots: none
- extra transitional roots: none
- status: aligned

## uDOS-dev

- class: operations
- expected roots: @dev automation courses docs scripts
- actual roots: .github @dev automation courses docs scripts
- missing recommended roots: none
- extra transitional roots: none
- status: aligned

## uDOS-themes

- class: standard
- expected roots: config docs examples scripts src tests
- actual roots: .github config docs examples scripts src tests
- missing recommended roots: none
- extra transitional roots: none
- status: aligned

## uDOS-docs

- class: docs
- expected roots: docs scripts tests config
- actual roots: .github alpine architecture config docs examples scripts tests uhome wizard
- missing recommended roots: none
- extra transitional roots: examples
- status: transitional

## uDOS-alpine

- class: packaging
- expected roots: docs scripts
- actual roots: .github apkbuild distribution docs examples openrc profiles scripts tests
- missing recommended roots: none
- extra transitional roots: examples tests
- status: transitional

## uHOME-client

- class: standard
- expected roots: config docs examples scripts src tests
- actual roots: .github config docs examples scripts src tests
- missing recommended roots: none
- extra transitional roots: none
- status: aligned

## uHOME-server

- class: service
- expected roots: config docs tests scripts services
- actual roots: .github apps config courses defaults docs examples library memory modules scheduling scripts services src tests uhome vault
- missing recommended roots: none
- extra transitional roots: none
- status: aligned

## uHOME-app-android

- class: standard
- expected roots: config docs examples scripts src tests
- actual roots: .github app config docs feature-kiosk feature-player feature-reader integrations scripts
- missing recommended roots: examples src tests
- extra transitional roots: app feature-kiosk feature-player feature-reader integrations
- status: transitional

## uHOME-app-ios

- class: standard
- expected roots: config docs examples scripts src tests
- actual roots: .github Docs Sources Tests config scripts
- missing recommended roots: docs examples src tests
- extra transitional roots: Docs Sources Tests
- status: transitional

