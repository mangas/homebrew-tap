#!/usr/bin/env bash
# Rewrites the formulas of each prefix in .releases/ (ci/update-fetch.sh) that has a newer
# release, and pushes one PR per prefix. Runs in the update-formulas pipeline's push step
# (ci-infra, the image with ssh).
# Env:
#   DEPLOY_KEY         private SSH deploy key with write access to fa/homebrew-tap
#                      (Secret homebrew-tap-deploy-key)
set -euo pipefail

: "${DEPLOY_KEY:?DEPLOY_KEY is not set: no PR can be pushed}"

declare -A formulas=(["mcpfile"]="mcpfile" ["graphctl-rs"]="gctl gctl-server gctl-mcp")

umask 077
keyfile=$(mktemp)
trap 'rm -f "$keyfile"' EXIT
printf '%s\n' "$DEPLOY_KEY" > "$keyfile"
export GIT_SSH_COMMAND="ssh -i $keyfile -o IdentitiesOnly=yes -o StrictHostKeyChecking=yes -o UserKnownHostsFile=$PWD/ci/known_hosts"

# TAP_REMOTE: where the PRs are pushed; ci/test-update-push.sh points it at a local repo.
remote=${TAP_REMOTE:-git@git.tofus.wtf:fa/homebrew-tap.git}
base=$(git rev-parse HEAD)
for prefix in mcpfile graphctl-rs; do
    sums=".releases/$prefix/SHA256SUMS"
    tag=$(cat ".releases/$prefix/tag")
    latest=${tag#v}
    read -r -a fs <<< "${formulas[$prefix]}"
    current=$(sed -nE 's/^  version "([^"]+)"$/\1/p' "Formula/${fs[0]}.rb")
    [[ $current =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || {
        echo "$prefix: Formula/${fs[0]}.rb has no X.Y.Z version line" >&2
        exit 1
    }
    echo "$prefix: current $current, latest $latest"
    newest=$(printf '%s\n%s\n' "$current" "$latest" | sort -V | tail -n 1)
    if [ "$current" = "$latest" ] || [ "$newest" = "$current" ]; then
        echo "$prefix: nothing to update"
        continue
    fi

    git checkout -q --detach "$base"
    for f in "${fs[@]}"; do
        file="Formula/$f.rb"
        darwin=$(awk -v a="$f-aarch64-darwin" '{ n = $2; sub(/^\*/, "", n) } n == a { print $1 }' "$sums")
        linux=$(awk -v a="$f-x86_64-linux" '{ n = $2; sub(/^\*/, "", n) } n == a { print $1 }' "$sums")
        # A binary dropped upstream (gctl-mcp) keeps its formula at the old version.
        if [ -z "$darwin" ] && [ -z "$linux" ]; then
            echo "$prefix: $f is not in $tag's SHA256SUMS, $file left at its version"
            continue
        fi
        for h in "$darwin" "$linux"; do
            [[ $h =~ ^[0-9a-f]{64}$ ]] || {
                echo "$prefix: $f: bad or missing sha256 in $tag's SHA256SUMS" >&2
                exit 1
            }
        done
        # The version line, and the sha256 line right after each asset's url line; every
        # one must be found exactly once, or the formula's shape changed.
        awk -v ver="$latest" -v da="$f-aarch64-darwin" -v dh="$darwin" -v la="$f-x86_64-linux" -v lh="$linux" '
            /^  version "[^"]+"$/ { sub(/"[^"]+"/, "\"" ver "\""); nv++ }
            hash != "" && /^ +sha256 "[0-9a-f]+"$/ { sub(/"[0-9a-f]+"/, "\"" hash "\""); ns++ }
            { hash = "" }
            $1 == "url" && $0 ~ ("/" da "\"$") { hash = dh }
            $1 == "url" && $0 ~ ("/" la "\"$") { hash = lh }
            { print }
            END { if (nv != 1 || ns != 2) { print FILENAME ": version or sha256 lines not where expected" > "/dev/stderr"; exit 1 } }
        ' "$file" > "$file.new"
        mv "$file.new" "$file"
        git add "$file"
    done

    title="Update $prefix formulas to v$latest"
    # Dated as the base commit, so a rerun with main unmoved makes the same SHA and its
    # push changes nothing on the open PR.
    date=$(git log -1 --format=%cI "$base")
    GIT_AUTHOR_DATE=$date GIT_COMMITTER_DATE=$date \
        git -c user.name="homebrew-tap CI" -c user.email=ci@tofus.wtf commit -q -m "$title"
    # AGit: a push to refs/for/main/<topic> opens a PR from the deploy key alone, and a
    # rerun with the same topic updates that PR (force-push: main may have moved since).
    # Fallback if Forgejo refuses AGit from a deploy key: push a plain branch,
    # HEAD:refs/heads/update-<prefix>-v<ver>, and open the PR by hand.
    git push "$remote" "HEAD:refs/for/main/update-$prefix-v$latest" \
        -o title="$title" \
        -o description="$prefix $tag from https://releases.tofus.wtf/$prefix/$tag/ (versions and sha256 from its SHA256SUMS), by the update-formulas pipeline." \
        -o force-push=true
done
