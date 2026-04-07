default: help

help:
    @just -l

# Trigger the update-formulas workflow manually
update-formulas:
    gh workflow run update-formulas.yml
