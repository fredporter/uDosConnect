# Linux first run — uDOS-host (public repo litmus)

Use this when a machine has **never** had the uDOS family checked out. You clone **`uDOS-host` only** from the public Git host; one script pulls the **runtime-spine** sibling repos (including **`uDOS-wizard`** for the Surface browser layer), installs common OS packages, adds minimal Python packages for Core tests, and runs **`runtime-spine-round-proof.sh`** (automated **[1/3][2/3]** only — you still owe **[3/3] browser GUI** per `uDOS-dev/docs/round-closure-three-steps.md`). **Host authority** for the spine stays with **Ubuntu** and `~/.udos/`; Wizard is orchestration and operator UI, not a second runtime spine (see `uDOS-dev/docs/gui-system-family-contract.md`).

## What you get

- Siblings next to `uDOS-host`: `uDOS-core`, `uDOS-grid`, `uDOS-wizard`, `uDOS-dev`, `uDOS-docs` (same layout as `cursor-01-runtime-spine.code-workspace`).
- **Debian/Ubuntu:** `apt-get install` for `git`, `curl`, `ca-certificates`, `python3`, `python3-venv`, `python3-pip`, `nodejs`, `npm`, and **`python3.11`** when the package exists (helps **uDOS-wizard** checks).
- **pip (user):** `pytest`, `jsonschema`, `referencing` if `pytest` is missing (for **uDOS-core**).
- **Verification:** **`scripts/runtime-spine-round-proof.sh`** completes automated **[1/3][2/3]** (must pass). **Step [3/3] — final GUI render** in a real browser is still **mandatory** to close Workspace 01; see **`uDOS-dev/docs/round-closure-three-steps.md`**.

## Requirements

- **OS:** Debian or Ubuntu (script uses `apt-get`). On other distros, install the equivalent packages manually and set `UDOS_SKIP_APT=1`.
- **Git** and network access to your Git host.
- **Python:** `uDOS-wizard` checks expect **Python 3.11+**. Ubuntu **24.04+** is ideal; on **22.04** the script tries `python3.11` from apt when available.
- **Node:** required for **`uDOS-docs`** checks (`generate-site-data.mjs --check`).

## One-command style flow

Replace `<ORG>` with your GitHub org or user (or your full base URL logic).

```bash
git clone --depth 1 https://github.com/<ORG>/uDOS-host.git
cd uDOS-host
bash scripts/linux-family-bootstrap.sh
```

The script discovers **`UDOS_FAMILY_GIT_BASE`** from **`git remote get-url origin`** (e.g. `https://github.com/<ORG>/uDOS-host.git` → `https://github.com/<ORG>`). If that fails (no remote), set it explicitly:

```bash
export UDOS_FAMILY_GIT_BASE=https://github.com/<ORG>
bash scripts/linux-family-bootstrap.sh
```

### Branch for shallow clones

Default is **`main`**. Override if your default branch differs:

```bash
export UDOS_FAMILY_BRANCH=master
bash scripts/linux-family-bootstrap.sh
```

### Custom layout

By default, siblings are cloned into the **parent** of `uDOS-host`. To use another directory:

```bash
export UDOS_FAMILY_ROOT="$HOME/src/uDOS-family"
mkdir -p "$UDOS_FAMILY_ROOT"
cd "$UDOS_FAMILY_ROOT"
git clone --depth 1 https://github.com/<ORG>/uDOS-host.git
cd uDOS-host
bash scripts/linux-family-bootstrap.sh
```

## After bootstrap succeeds

**Invoking scripts:** use `bash scripts/<name>.sh` from the `uDOS-host` root, or `cd scripts && ./<name>.sh`. A bare `<name>.sh` will not resolve unless that directory is on your `PATH`.

**After bootstrap:** you still owe **step [3/3]** — open the command-centre in a **browser** and record sign-off (`uDOS-dev/docs/round-closure-three-steps.md`).

1. **Browser (static command-centre GUI):**

   ```bash
   bash scripts/serve-command-centre-demo.sh
   ```

   Open the printed URL (usually `http://127.0.0.1:7107/`).

2. **Automated HTTP check (no browser):**

   ```bash
   bash scripts/verify-command-centre-http.sh
   ```

3. **Re-run full litmus later:**

   ```bash
   bash scripts/runtime-spine-round-proof.sh
   ```

## Re-run anytime (self-upgrade + self-heal)

The same command **updates** the install:

```bash
cd uDOS-host
bash scripts/linux-family-bootstrap.sh
```

By default it will:

- **`git fetch` / fast-forward** this **`uDOS-host`** repo to **`origin/$UDOS_FAMILY_BRANCH`** (default `main`). If new commits land, the script **re-invokes itself once** so you always run the **latest** `linux-family-bootstrap.sh` from the repo.
- **Pull** sibling repos (`uDOS-core`, `uDOS-grid`, …) with **fast-forward** only.
- **Heal** broken sibling trees: empty folder, missing `.git`, or corrupt git → **remove and re-clone** (with retries).
- **Refresh** bootstrap pip packages (`pytest`, `jsonschema`, `referencing`) with **`-U`**.

If your local checkout has **commits not on origin**, fast-forward will fail until you merge, rebase, or **discard**:

```bash
export UDOS_BOOTSTRAP_RESET_HARD=1
bash scripts/linux-family-bootstrap.sh
```

That resets **`uDOS-host`** and each sibling (when pull fails) to **`origin/$BRANCH`**. Use only when you accept losing local diffs.

Optional OS package upgrades:

```bash
export UDOS_APT_UPGRADE=1
bash scripts/linux-family-bootstrap.sh
```

## Optional environment flags

| Variable | Effect |
| --- | --- |
| `UDOS_SKIP_APT=1` | Do not run `apt-get` (you installed deps yourself). |
| `UDOS_SKIP_ROUND_PROOF=1` | Only clone + pip prep; skip the long proof (then run it manually). |
| `UDOS_SKIP_SELF_UPGRADE=1` | Do not pull or re-exec **`uDOS-host`** (frozen tree). |
| `UDOS_SKIP_SIBLING_UPGRADE=1` | Do not `git pull` siblings (still heal missing/corrupt clones). |
| `UDOS_SKIP_PIP_UPGRADE=1` | Only install pip deps if missing (no `-U`). |
| `UDOS_APT_UPGRADE=1` | After `apt-get install`, run **`apt-get upgrade -y`**. |
| `UDOS_BOOTSTRAP_RESET_HARD=1` | On ff-only failure, **`git reset --hard origin/$BRANCH`** for ubuntu + siblings. |
| `UDOS_BOOTSTRAP_INSTALL_LAN_SERVICE=1` | After bootstrap, install **`systemd --user`** unit for LAN command-centre (`docs/lan-command-centre-persistent.md`). |

## Leave the command-centre on the LAN (before closing the round)

If the bootstrap **succeeds** and this machine will stay in service while you move to **cursor-02** or later lanes:

1. Read **`docs/lan-command-centre-persistent.md`** (firewall, linger, security).
2. Either run **`bash scripts/serve-command-centre-demo-lan.sh`** under **tmux** / **screen**, or install the **systemd user** unit:

   ```bash
   bash scripts/install-command-centre-demo-lan-user-service.sh --now
   ```

3. One-shot after a green bootstrap:

   ```bash
   export UDOS_BOOTSTRAP_INSTALL_LAN_SERVICE=1
   bash scripts/linux-family-bootstrap.sh
   ```

Other devices on the same network can use **`http://<host-LAN-IP>:7107/`** (or your `UDOS_WEB_PORT`).

## Closing this round / next workspace

When this litmus passes on your Linux host, **Workspace 01 (runtime spine)** is operationally closed for your environment. Switch Cursor to **`cursor-02-foundation-distribution.code-workspace`** for install, Sonic, Ventoy, and distribution work (`docs/cursor-execution.md`).

Canonical pathway notes: `uDOS-dev/@dev/pathways/runtime-spine-workspace-round-closure.md`.

**Workspace 02 (foundation / distribution):** read **`uDOS-dev/docs/foundation-distribution.md`** for Sonic-first install order, `~/.udos/` ownership, and the Sonic/Ventoy split. After cloning **Sonic** (adjacent family root) and any extra siblings that workspace lists, run **`bash scripts/foundation-distribution-workspace-proof.sh`** from **`uDOS-host`** for the full lane-2 automated gate (still complete **step 3 — browser** on the command-centre demo per `uDOS-dev/docs/round-closure-three-steps.md`). Pathway: **`uDOS-dev/@dev/pathways/foundation-distribution-workspace-round-closure.md`**.
