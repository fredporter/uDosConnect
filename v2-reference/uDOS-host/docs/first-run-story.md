# Ubuntu First-Run Story

This is the intended first-run setup story for the current `uDOS-host` lane.

## Sequence

1. boot into the Ubuntu base image staged by Sonic
2. apply `sonic-hooks/preinstall.sh`, `postinstall.sh`, and `live-env.sh`
3. verify package baseline from `config/packages.list`
4. verify the local runtime home and repo-store roots under `~/.udos/`
5. open the browser command-centre home scaffold as the operator shell
6. hand off to `uDOS-shell` quickstart and startup health summary
7. optionally launch the ThinUI C64 first-run panel

Optional repo-store bootstrap after first run:

```bash
bash scripts/udos-gitd.sh init-layout
bash scripts/udos-gitd.sh repo-list
```

## Demo Entry

```bash
bash scripts/demo-first-run-setup.sh
```

Browser command-centre demo entry:

```bash
bash scripts/demo-browser-workstation.sh
```

## Lane 1 closure proof (runtime spine)

**Terminal (Core + Grid + Ubuntu):** from `uDOS-host`, with `uDOS-core` and
`uDOS-grid` as sibling repos:

```bash
bash scripts/lane1-runtime-proof-tui.sh
```

**Browser (static command-centre page):** in another shell:

```bash
bash scripts/serve-command-centre-demo.sh
```

Open `http://127.0.0.1:7107/` — you should see the “uDOS command centre” page.
  (Same `UDOS_WEB_BIND` / `UDOS_WEB_PORT` as `config/env/udos-web.env.example`; see
  `contracts/udos-web/command-centre-static-demo.v1.json`.)

(`uDOS-dev` / `uDOS-docs` proof can wait for a later lane.)

## ThinUI Payload

- `examples/thinui-c64-launch.json`

## Browser Command-Centre Payload

- `examples/browser-workstation-scaffold.json`
