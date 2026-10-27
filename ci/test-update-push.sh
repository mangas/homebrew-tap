#!/usr/bin/env bash
# Scenario tests of ci/update-push.sh: each runs it on a copy of this repo's formulas and
# ci/ with a fixture .releases/, pushing to a local bare repo (TAP_REMOTE) instead of
# Forgejo, and checks what was pushed. Needs git, bash and awk only (`just test`).
# The predicates run through check "$@", which shellcheck cannot follow.
# shellcheck disable=SC2329
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
failed=0

h() { printf '%064d' "$1"; } # a fake sha256 per number

# A fresh tap at mcpfile 1.0.0 and graphctl-rs 2.0.0, with a bare remote; cd's into it.
setup() {
    local dir="$work/$1"
    mkdir -p "$dir"
    git init -q --bare "$dir/remote.git"
    git -C "$dir/remote.git" config receive.advertisePushOptions true
    git init -q -b main "$dir/tap"
    cp -r "$root/Formula" "$root/ci" "$dir/tap/"
    cd "$dir/tap"
    sed -i -E 's/^  version "[^"]+"$/  version "1.0.0"/' Formula/mcpfile.rb
    sed -i -E 's/^  version "[^"]+"$/  version "2.0.0"/' Formula/gctl*.rb
    commit base
    export TAP_REMOTE="$dir/remote.git" DEPLOY_KEY=unused
}

commit() {
    git add -A Formula ci
    git -c user.name=t -c user.email=t@t commit -q -m "$1"
}

# release <prefix> <tag> <SHA256SUMS lines...>
release() {
    local prefix=$1 tag=$2
    shift 2
    mkdir -p ".releases/$prefix"
    printf '%s\n' "$tag" > ".releases/$prefix/tag"
    printf '%s\n' "$@" > ".releases/$prefix/SHA256SUMS"
}

mcpfile_at() { release mcpfile "v$1" "$(h 1)  mcpfile-aarch64-darwin" "$(h 2)  mcpfile-x86_64-linux"; }

run_update() { ci/update-push.sh > /dev/null 2>&1; }

# Predicates over what reached the remote.
pushed() { git -C "$TAP_REMOTE" for-each-ref --format='%(refname)' refs/for; }
pushed_are() { [ "$(pushed | sort)" = "$(printf '%s\n' "$@" | sort)" ]; }
nothing_pushed() { [ -z "$(pushed)" ]; }
# version_is <ref> <formula> <version>
version_is() { git -C "$TAP_REMOTE" show "$1:Formula/$2.rb" | grep -qx "  version \"$3\""; }
# hash_after <ref> <formula> <asset> <sha256>: the sha256 line right after the asset's url
hash_after() { git -C "$TAP_REMOTE" show "$1:Formula/$2.rb" | grep -A1 "/$3\"" | grep -q "sha256 \"$4\""; }
fails() { ! "$@"; }

# check <name> <command...>
check() {
    local name=$1
    shift
    if "$@"; then
        echo "ok   $name"
    else
        echo "FAIL $name: $*"
        failed=1
    fi
}

test_newer_release_opens_one_pr_per_tool() {
    setup newer
    mcpfile_at 1.0.1
    release graphctl-rs v2.1.0 \
        "$(h 3)  gctl-aarch64-darwin" "$(h 4)  gctl-x86_64-linux" \
        "$(h 5)  gctl-server-aarch64-darwin" "$(h 6)  gctl-server-x86_64-linux" \
        "$(h 7)  gctl-mcp-aarch64-darwin" "$(h 8)  gctl-mcp-x86_64-linux"
    run_update
    local m=refs/for/main/update-mcpfile-v1.0.1 g=refs/for/main/update-graphctl-rs-v2.1.0
    check "newer release: one ref per tool" pushed_are "$m" "$g"
    check "newer release: mcpfile version" version_is "$m" mcpfile 1.0.1
    check "newer release: mcpfile darwin hash" hash_after "$m" mcpfile mcpfile-aarch64-darwin "$(h 1)"
    check "newer release: mcpfile linux hash" hash_after "$m" mcpfile mcpfile-x86_64-linux "$(h 2)"
    check "newer release: gctl-server darwin hash" hash_after "$g" gctl-server gctl-server-aarch64-darwin "$(h 5)"
    check "newer release: gctl-mcp linux hash" hash_after "$g" gctl-mcp gctl-mcp-x86_64-linux "$(h 8)"
    check "newer release: mcpfile PR leaves gctl alone" version_is "$m" gctl 2.0.0
    check "newer release: graphctl PR leaves mcpfile alone" version_is "$g" mcpfile 1.0.0
}

test_same_release_pushes_nothing() {
    setup same
    mcpfile_at 1.0.0
    release graphctl-rs v2.0.0 "$(h 3)  gctl-aarch64-darwin" "$(h 4)  gctl-x86_64-linux"
    run_update
    check "same release: nothing pushed" nothing_pushed
}

test_older_release_is_not_a_downgrade() {
    setup older
    mcpfile_at 0.9.10
    release graphctl-rs v2.0.0
    run_update
    check "older release: nothing pushed" nothing_pushed
}

test_version_compare_is_semver() {
    setup semver
    sed -i 's/version "1.0.0"/version "1.0.9"/' Formula/mcpfile.rb
    commit 1.0.9
    mcpfile_at 1.0.10
    release graphctl-rs v2.0.0
    run_update
    check "semver: 1.0.10 is newer than 1.0.9" pushed_are refs/for/main/update-mcpfile-v1.0.10
}

test_binary_dropped_upstream_keeps_its_formula() {
    setup dropped
    mcpfile_at 1.0.0
    release graphctl-rs v2.1.0 \
        "$(h 3)  gctl-aarch64-darwin" "$(h 4)  gctl-x86_64-linux" \
        "$(h 5)  gctl-server-aarch64-darwin" "$(h 6)  gctl-server-x86_64-linux"
    run_update
    local g=refs/for/main/update-graphctl-rs-v2.1.0
    check "dropped binary: the others are updated" version_is "$g" gctl 2.1.0
    check "dropped binary: gctl-mcp keeps its version" version_is "$g" gctl-mcp 2.0.0
}

test_one_missing_asset_fails() {
    setup missing
    release mcpfile v1.0.1 "$(h 1)  mcpfile-aarch64-darwin"
    release graphctl-rs v2.0.0
    check "one asset missing: the run fails" fails run_update
    check "one asset missing: nothing pushed" nothing_pushed
}

test_rerun_pushes_the_same_commit() {
    setup rerun
    mcpfile_at 1.0.1
    release graphctl-rs v2.0.0
    run_update
    local ref=refs/for/main/update-mcpfile-v1.0.1 first
    first=$(git -C "$TAP_REMOTE" rev-parse "$ref")
    git checkout -q main
    sleep 1 # a commit dated now would get a new SHA
    run_update
    check "rerun: same commit" [ "$first" = "$(git -C "$TAP_REMOTE" rev-parse "$ref")" ]
}

test_newer_release_opens_one_pr_per_tool
test_same_release_pushes_nothing
test_older_release_is_not_a_downgrade
test_version_compare_is_semver
test_binary_dropped_upstream_keeps_its_formula
test_one_missing_asset_fails
test_rerun_pushes_the_same_commit
exit "$failed"
