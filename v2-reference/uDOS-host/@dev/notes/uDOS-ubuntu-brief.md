uDOS-host

uDOS v2 — Base OS Distribution & Boot System

⸻

Purpose

uDOS-host defines the canonical base operating system layer for uDOS v2 deployments.

It provides:
	•	a minimal, reproducible Ubuntu 22 LTS base image
	•	preconfigured uDOS runtime compatibility
	•	integrated Proton software suite
	•	optional secure networking (Proton VPN)
	•	custom uDOS visual identity (boot + GUI skin)
	•	full compatibility with sonic-screwdriver deployment workflows

This repo is not a fork of Ubuntu.

It is:

a curated, reproducible system image definition for uDOS environments

⸻

Core Principles

1. Minimal, Stable, Reproducible
	•	Based on Ubuntu 22.04 LTS (minimal)
	•	No unnecessary packages
	•	Deterministic build process (scriptable image generation)

⸻

2. uDOS is Layered, Not Embedded
	•	uDOS is not baked into the OS
	•	uDOS-core, shell, and extensions install on top
	•	OS remains replaceable

⸻

3. Sonic-Screwdriver First-Class Target
	•	Primary install path is via sonic-stick (USB boot device)
	•	Must support:
	•	Live boot (run from USB)
	•	Full install to disk
	•	Recovery/reinstall workflows

⸻

4. Privacy + Sovereignty by Default
	•	Proton suite included for:
	•	mail
	•	docs
	•	identity
	•	Optional:
	•	Proton VPN
	•	encrypted storage layers

⸻

5. Visual Identity Matters
	•	uDOS should feel distinct at OS level
	•	Blend:
	•	classic Mac (System 7 style)
	•	modern macOS polish (ThemeKit)

⸻

Repo Responsibilities

Owns:
	•	Ubuntu base image definition
	•	Package selection + system config
	•	Proton integration layer
	•	Bootloader branding (uDOS bootstrap)
	•	Desktop environment + theming
	•	Compatibility layer for uDOS-core install
	•	Sonic-screwdriver install hooks

⸻

High-Level Architecture

uDOS-host
├── build/
│   ├── iso/
│   ├── rootfs/
│   └── scripts/
│
├── config/
│   ├── packages.list
│   ├── system/
│   ├── users/
│   └── services/
│
├── proton/
│   ├── install.sh
│   ├── config/
│   └── optional/
│       └── vpn/
│
├── theming/
│   ├── themekit/
│   ├── system7/
│   ├── gtk/
│   ├── icons/
│   └── fonts/
│
├── boot/
│   ├── grub/
│   ├── plymouth/
│   └── sonic-menu/
│
├── sonic-hooks/
│   ├── preinstall.sh
│   ├── postinstall.sh
│   └── live-env.sh
│
└── docs/


⸻

Base System Specification

OS
	•	Ubuntu 22.04 LTS (minimal)
	•	Kernel: LTS generic (with optional hardware enablement)

⸻

Desktop Environment

Recommended:
	•	XFCE or LXDE (lightweight, themeable)

Reason:
	•	Fast on low-end machines
	•	Fully themeable for Mac/System7 hybrid UI
	•	Stable

⸻

Drivers

Include:
	•	Common GPU drivers (mesa, optional NVIDIA installer)
	•	WiFi + Bluetooth essentials
	•	Input device support (gamepad-ready for uHOME crossover)

⸻

Proton Integration

Core Suite

Preinstall or first-boot install:
	•	Proton Mail (web app or bridge)
	•	Proton Drive
	•	Proton Docs (via web/PWA model)
	•	Proton Pass (optional)

⸻

Optional (Wizard-enabled or user opt-in)
	•	Proton VPN
	•	Proton Mail Bridge (for desktop clients)

⸻

Integration Approach
	•	Use PWA-style wrappers OR native bridge where required
	•	Store credentials in:
	•	user vault (uDOS layer)
	•	or OS keychain fallback

⸻

Sonic-Screwdriver Integration

Role

sonic-screwdriver must be able to:
	1.	Download latest uDOS-host build
	2.	Prepare USB (sonic-stick)
	3.	Install boot system
	4.	Inject config (user/device specific)
	5.	Enable live + install modes

⸻

Sonic-Stick Capabilities
	•	Boot menu (like Ventoy, but uDOS styled)
	•	Multiple modes:
	•	Live OS
	•	Install OS
	•	Recovery tools

⸻

Boot Menu UI

TUI-based, styled as:
	•	uDOS terminal aesthetic
	•	selectable entries
	•	keyboard/gamepad navigation

⸻

USB Formatting + Partitioning (Important)

You’re correct — this is the constraint.

Required Layout for Universal Boot

Best practice:

USB (GPT partition table)
├── Partition 1: FAT32 (EFI boot)
├── Partition 2: exFAT or ext4 (ISO / persistence)


⸻

Why FAT32?
	•	Required for UEFI boot compatibility
	•	Works across:
	•	Linux
	•	Windows
	•	macOS (read/write)

⸻

Why Not Only FAT32?
	•	FAT32 file size limit = 4GB
	•	Ubuntu ISOs can approach/exceed this

⸻

Recommended Strategy

Use Ventoy-style approach:
	•	Small FAT32 EFI partition
	•	Larger exFAT partition for ISOs

⸻

macOS Limitation (You’re Right)

macOS:
	•	Cannot easily create multi-partition bootable USBs in the same flexible way
	•	Disk Utility is restrictive

⸻

Solutions

Option A — Linux Only (Current)
	•	Keep sonic-screwdriver Linux-native

Option B — Preformatted Stick (Recommended)
	•	Provide:
	•	downloadable image OR
	•	one-time Linux prep script

Then macOS users can:
	•	reuse the stick
	•	update ISOs only

⸻

Option C — macOS Support (Advanced)
Use:
	•	diskutil + gpt CLI
	•	Still limited, but possible with scripting

👉 Recommendation:

Support macOS only for updating, not initial formatting

⸻

Boot Experience (uDOS Identity Layer)

1. GRUB Theme
	•	Custom uDOS theme
	•	Minimal + retro hybrid aesthetic

⸻

2. Plymouth Boot Screen

Custom splash:
	•	uDOS logo
	•	subtle animation
	•	“booting binder layer…” style messaging

⸻

3. Sonic Boot Menu

Before OS loads:
	•	uDOS-styled TUI selector
	•	resembles:
	•	terminal OS
	•	retro system menu

⸻

GUI Theming System

Design Direction

Blend:

Modern Mac Style
	•	via ThemeKit
	•	soft gradients, spacing, typography

System 7 Retro Layer
	•	sharp edges
	•	pixel icons
	•	grayscale UI option

⸻

Implementation
	•	GTK theme overrides
	•	icon packs
	•	font system (uDOS font layer compatible)
	•	window manager styling

⸻

Theme Modes
	•	udos-modern
	•	udos-retro
	•	udos-minimal

Switchable via:
	•	CLI
	•	settings panel (future)

⸻

uDOS Bootstrap Layer

On first boot:
	1.	Show uDOS welcome screen
	2.	Run:
	•	user setup
	•	network detection
	•	optional Proton login
	3.	Offer:
	•	install uDOS-core
	•	connect to Wizard
	•	configure Vault

⸻

Relationship to Other Repos

uDOS-core
	•	installs on top of this OS
	•	uses OS only for execution layer

⸻

uDOS-shell
	•	primary interface after bootstrap

⸻

uHOME
	•	can run as:
	•	server on this OS
	•	or client connecting to external server

⸻

sonic-screwdriver
	•	primary installer + distributor

⸻

Non-Goals
	•	Not a general-purpose Linux distro
	•	Not a fork of Ubuntu ecosystem
	•	Not a GUI-first OS
	•	Not tied permanently to Ubuntu (future replaceable)

⸻

Future Extensions
	•	ARM builds (Raspberry Pi / edge devices)
	•	Immutable OS mode (read-only system)
	•	Encrypted-by-default installs
	•	Multi-user uDOS environments
	•	Offline-first bundle mode

⸻

Summary

uDOS-host is the foundation layer.

It provides:
	•	a clean, reproducible OS
	•	a privacy-respecting software base
	•	a branded uDOS experience from boot to desktop
	•	seamless deployment via sonic-screwdriver

Without:
	•	locking uDOS into a specific OS long-term
