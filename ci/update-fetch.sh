#!/usr/bin/env bash
# Writes each release prefix's latest released vX.Y.Z and its SHA256SUMS to
# .releases/<prefix>/{tag,SHA256SUMS}, for ci/update-push.sh. Runs in the update-formulas
# pipeline's fetch step (rust-release, the image with rclone): it needs the in-cluster
# RustFS endpoint.
# Env:
#   RCLONE_S3_ACCESS_KEY_ID, RCLONE_S3_SECRET_ACCESS_KEY  read-only RustFS key that may list
#                      releases/mcpfile/ and releases/graphctl-rs/ (Secret homebrew-tap-releases)
set -euo pipefail

: "${RCLONE_S3_ACCESS_KEY_ID:?RCLONE_S3_ACCESS_KEY_ID is not set}"
: "${RCLONE_S3_SECRET_ACCESS_KEY:?RCLONE_S3_SECRET_ACCESS_KEY is not set}"

# rclone's S3 backend from the environment alone, as mcpfile's publish recipe does.
export RCLONE_S3_PROVIDER=Minio RCLONE_S3_ENDPOINT=http://rustfs.rustfs.svc.cluster.local:9000 \
    RCLONE_S3_FORCE_PATH_STYLE=true RCLONE_S3_NO_CHECK_BUCKET=true

# The release prefixes in bucket releases (https://releases.tofus.wtf/<prefix>/), one PR
# each; ci/update-push.sh maps each to its formulas.
for prefix in mcpfile graphctl-rs; do
    # Captured first: a failed listing stops the script here, where inside the for list
    # below its exit status would be ignored.
    listing=$(rclone lsf --dirs-only ":s3:releases/$prefix/")
    tag=""
    # A version dir exists before its SHA256SUMS is uploaded, so a version counts as
    # released only once SHA256SUMS is in its listing.
    for t in $(printf '%s\n' "$listing" | sed 's|/$||' | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort -Vr); do
        files=$(rclone lsf --files-only ":s3:releases/$prefix/$t/")
        if printf '%s\n' "$files" | grep -qx SHA256SUMS; then
            tag=$t
            break
        fi
        echo "$prefix: $t has no SHA256SUMS yet, not released"
    done
    [ -n "$tag" ] || {
        echo "$prefix: no released vX.Y.Z in releases/$prefix/" >&2
        exit 1
    }
    mkdir -p ".releases/$prefix"
    # The objects are public: an anonymous GET, as users get them.
    rclone copyurl "$RCLONE_S3_ENDPOINT/releases/$prefix/$tag/SHA256SUMS" ".releases/$prefix/SHA256SUMS"
    printf '%s\n' "$tag" > ".releases/$prefix/tag"
    echo "$prefix: latest released $tag"
done
