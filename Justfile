default: help

help:
    @just -l

# Run .woodpecker/update-formulas.yaml now, as its 6-hourly cron does
update-formulas:
    woodpecker-cli pipeline create --branch main fa/homebrew-tap

# shellcheck and shfmt over ci/*.sh (shfmt flags: the scripts' style)
check-shell:
    shellcheck ci/*.sh
    shfmt -d -i 4 -bn -sr ci/*.sh

# yamllint over the pipelines (.yamllint.yaml) and just's formatter over this file
lint:
    yamllint -c .yamllint.yaml .
    just --unstable --fmt --check

# Scenario tests of ci/update-push.sh against a local bare repo
test:
    ci/test-update-push.sh
