---
description: 'Repository-wide forward-only maintenance, versioning and continuous integration conventions.'
applyTo: '**'
---

# GitHub

## Forward-Only Maintenance

- Maintain only current supported behavior. Remove deprecated, retired, legacy and no-op code instead of preserving compatibility aliases or shims.
- Prefer a clean versioned release over compatibility code. Consumers remain on an older immutable tag until they are ready to migrate.
- Remove commented-out implementations and speculative placeholders. Git retains history.

## Branch Naming

- Name feature branches `<github_username>/yyyy-MM-concise-name`, for example `<github_username>/2026-09-tf-docs`.
- Use the branch creation year and month followed by concise, lowercase kebab-case wording.

## Pull Requests

- Inspect the repository's available labels when creating a pull request and apply every label that accurately describes the change.
- Assign a new pull request to the currently authenticated GitHub user. Resolve the login dynamically from the GitHub client or API; never hardcode a username in instructions or automation.
- Verify the pull request's base branch, head branch, labels and assignee after creation.

## Continuous Integration

- Pull requests must run Terraform formatting, backend-free initialization and validation without Azure credentials.
- Require `lint / lint`, `versioning / gha-release-versioning` and `validate / terraform validate` as status checks in the `main` branch ruleset.

## Dependency Automation

- Configure Dependabot's `terraform` ecosystem for `src/` so provider and module version constraints are monitored.
- Keep dependency ranges in child modules broad within the current supported provider major. Do not commit a dependency lock file for a reusable child module.
- Configure Dependabot's `helm` ecosystem in repositories containing Helm charts, with one entry per chart directory or a `directories` pattern covering every `Chart.yaml`.
- Validate automated provider-major and chart updates through the same pull request checks as manually authored changes.
