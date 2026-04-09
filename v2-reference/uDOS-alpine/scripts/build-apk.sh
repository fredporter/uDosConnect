#!/bin/sh
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
APKBUILD_FILE="$REPO_ROOT/apkbuild/APKBUILD"
DIST_DIR="$REPO_ROOT/distribution/packages"
BUILD_ROOT="$REPO_ROOT/.build/alpine-apk"

pkg_meta() {
    awk -F= -v key="$1" '$1 == key { gsub(/"/, "", $2); print $2 }' "$APKBUILD_FILE"
}

PKGNAME="$(pkg_meta pkgname)"
PKGVER="$(pkg_meta pkgver)"
PKGREL="$(pkg_meta pkgrel)"
ARCHIVE_NAME="${PKGNAME}-${PKGVER}-r${PKGREL}.tar.gz"
STAGE_DIR="$BUILD_ROOT/${PKGNAME}-${PKGVER}"
ROOTFS_DIR="$STAGE_DIR/rootfs"
SUMMARY_FILE="$DIST_DIR/${PKGNAME}-${PKGVER}-r${PKGREL}.build.json"
ARCHIVE_PATH="$DIST_DIR/$ARCHIVE_NAME"
ARCHIVE_RELATIVE_PATH="distribution/packages/$ARCHIVE_NAME"
STAGED_ROOT_RELATIVE_PATH=".build/alpine-apk/${PKGNAME}-${PKGVER}/rootfs"

rm -rf "$BUILD_ROOT"
mkdir -p "$ROOTFS_DIR/usr/share/udos-alpine/profiles"
mkdir -p "$ROOTFS_DIR/etc/init.d"
mkdir -p "$ROOTFS_DIR/etc/conf.d"
mkdir -p "$DIST_DIR"

cp "$REPO_ROOT/profiles/thinui-c64-launch.json" \
  "$ROOTFS_DIR/usr/share/udos-alpine/profiles/thinui-c64-launch.json"
cp "$REPO_ROOT/openrc/udos-thinui-launcher.initd" \
  "$ROOTFS_DIR/etc/init.d/udos-thinui-launcher"
cp "$REPO_ROOT/openrc/udos-thinui-launcher.confd" \
  "$ROOTFS_DIR/etc/conf.d/udos-thinui-launcher"
chmod 755 "$ROOTFS_DIR/etc/init.d/udos-thinui-launcher"
chmod 644 "$ROOTFS_DIR/etc/conf.d/udos-thinui-launcher"

cat > "$STAGE_DIR/BUILD-MANIFEST.json" <<EOF
{
  "package": "$PKGNAME",
  "version": "$PKGVER",
  "release": "$PKGREL",
  "artifact": "$ARCHIVE_NAME",
  "profile": "thinui-c64-launch.json",
  "service": "udos-thinui-launcher"
}
EOF

tar -czf "$ARCHIVE_PATH" -C "$STAGE_DIR" .

cat > "$SUMMARY_FILE" <<EOF
{
  "package": "$PKGNAME",
  "version": "$PKGVER",
  "release": "$PKGREL",
  "archive_path": "$ARCHIVE_RELATIVE_PATH",
  "staged_root": "$STAGED_ROOT_RELATIVE_PATH",
  "included_paths": [
    "usr/share/udos-alpine/profiles/thinui-c64-launch.json",
    "etc/init.d/udos-thinui-launcher",
    "etc/conf.d/udos-thinui-launcher"
  ]
}
EOF

printf '%s\n' "Staged Alpine package root at: $ROOTFS_DIR"
printf '%s\n' "Wrote package preview archive: $ARCHIVE_PATH"
printf '%s\n' "Wrote build summary: $SUMMARY_FILE"
