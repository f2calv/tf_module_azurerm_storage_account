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

## Semantic Versioning

- Before adding a `+semver:` directive, inspect every commit between the merge base with `origin/main` and `HEAD`.
- A branch must contain exactly one `+semver:` directive. If one already exists, do not add another to a later commit.
- Use `+semver:feature` for a breaking module change, including removed or renamed inputs, outputs and resource addresses.
- Place the directive in the commit that introduces the versioned behavior. Do not repeat it in documentation, formatting or release-tag synchronization commits.
- After the branch is complete, run GitVersion using the repository's `GitVersion.yml` and verify the numeric major, minor and patch result before creating a pull request.

## Release References

- Keep the module source example in `README.md` pinned to the immutable tag that GitVersion predicts for the final branch.
- Exclude feature-branch prerelease labels from the README tag.
- Recalculate the expected tag after the final commit. Do not assume that an earlier calculation remains valid.
- Tag reusable Terraform modules with plain `X.Y.Z` semantic versions.
- Reserve `v`-prefixed tags, such as `vX.Y.Z`, for GitHub Actions.
- Do not add CI or pre-release suffixes to releases from the `main` branch.

## Continuous Integration

- Pull requests must run Terraform formatting, backend-free initialization and validation without Azure credentials.
- Treat a mismatch between the GitVersion result and the README module source tag as a failed check.
- Reusable release-versioning workflow calls for Terraform modules must set `tag-prefix: ''` and `move-major-tag: false`.
- Require the validation job in the `main` branch ruleset before allowing a pull request to merge.

## Dependency Automation

- Configure Dependabot's `terraform` ecosystem for `src/` so provider and module version constraints are monitored.
- Keep dependency ranges in child modules broad within the current supported provider major. Do not commit a dependency lock file for a reusable child module.
- Configure Dependabot's `helm` ecosystem in repositories containing Helm charts, with one entry per chart directory or a `directories` pattern covering every `Chart.yaml`.
- Validate automated provider-major and chart updates through the same pull request checks as manually authored changes.
