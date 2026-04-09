# thinui adapters

This folder contains the uDOS-themes adapter layer for `uDOS-thinui`.

It converts theme packs into stable thinui render contracts so that:

- `uDOS-themes` owns appearance
- `uDOS-thinui` owns local GUI runtime behavior
- `uDOS-core` remains semantic source of truth

## Responsibilities

- resolve thinui theme manifests
- map external/forked theme assets into thinui-safe components
- expose loader patterns, fonts, and panel render tokens
- provide fallback rendering for low-resource and recovery modes

## Initial adapter targets

- `thinui-c64`
- `thinui-nes-sonic`
- `minimal-safe`

## Contract rule

Adapters must never mutate runtime semantics.
They only transform visual assets and view tokens into renderable thinui surfaces.
