---
description: 'Terraform authoring conventions for this reusable module — formatting, versions, variables, resources, outputs and security.'
applyTo: '**/*.tf,**/*.tfvars,**/*.hcl'
---

# Terraform

This repository publishes a single reusable module under `src/`, consumed over a pinned Git source. It declares no backend, no provider configuration and no state of its own — the calling root module owns all three.

## Formatting

- Run `terraform fmt -recursive` before every commit. All `.tf` files must pass with no changes.
- 2-space indentation, Terraform's default. Let `fmt` handle argument alignment; never hand-align.
- Use `#` for comments. Avoid `//` — `fmt` leaves it untouched, so it drifts from the rest of the file.

## Versions

- Declare a `terraform {}` block in `versions.tf` with `required_version` set to the oldest Terraform the module's syntax needs. Constrain each provider to the current supported major with permissive lower and exclusive upper bounds, such as `>= 5.0, < 6.0`.
- **Never pin an exact version here.** A child module pinning `= 4.81.0` cannot be composed with a caller or a sibling module that needs anything else. Exact pins and the dependency lock file belong to the root module.
- **Do not declare `provider` blocks.** Providers are inherited from the caller, which may pass a specific alias via `providers = { ... }`.

## File Conventions

| File | Purpose |
| --- | --- |
| `src/main.tf` | Resource and `data` blocks |
| `src/variables.tf` | Input variable declarations |
| `src/outputs.tf` | Output values |
| `src/versions.tf` | `terraform {}` block with `required_version` and `required_providers` |

- Keep the module focused on a single resource type or a tightly coupled group, and expose all customisation through variables.
- `README.md` documents usage, every variable and every output. Update it in the same commit as any interface change.

## Variables

- Every variable declares a `type` and a `description`. The description states what the value *is*, in one line.
- Names are `snake_case` and descriptive.
- Give a `default` only where a sensible one exists. A value the caller must own — a name, a parent resource id — stays required.
- Prefer a `map(string)` or `map(object({...}))` over parallel lists so `for_each` keys stay stable and readable.

## Resources and Data Sources

- **Name the primary resource `this`.** Secondary resources take a descriptive suffix: `this_pv`, `this_secret`.
- **Registry comment-link above each resource block**, pointing at the provider documentation for that resource type:

  ```hcl
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights
  resource "azurerm_application_insights" "this" {
  ```

- **Accept ids rather than creating shared dependencies.** A resource that could reasonably be shared by several callers — a workspace, a resource group, a vnet — is passed in by id, not created here. Creating it inside the module hands its lifecycle to whichever caller happened to instantiate the module first.
- **`for_each` over `count`.** Use `for_each` with a map for any multi-instance resource; it produces stable, readable state keys. Reserve `count` for the boolean on/off idiom, `count = var.feature_enabled ? 1 : 0`.
- **Tags**: every taggable resource sets `tags = var.tags`.
- **No `lifecycle { prevent_destroy = true }` here.** It is the caller's decision and, once published in a module, it blocks a `terraform destroy` the caller may legitimately want.

## Outputs

- Every output declares a `description`.
- Mark every key, password, connection string and certificate output `sensitive = true`.
- Source an output from the resource that owns it, so the value is not silently echoing an input back to the caller.

## Security

- **No secrets in the module.** Never hardcode a key, connection string or credential, and never give a variable a secret default.
- **Sensitive outputs** are marked `sensitive = true` so they are redacted from plan output and CI logs.
- Terraform writes output values into the caller's state, so a sensitive output is only as protected as their state backend. Keep the surface minimal — expose an id or an endpoint rather than a raw key wherever the caller can look the secret up itself.

## Forward-Only Maintenance

- Maintain only the current supported interface. Deprecated or retired provider arguments, outputs, SKUs, APIs and platform features have no place in the module.
- Remove obsolete inputs and outputs instead of retaining aliases, compatibility shims, no-op variables or commented legacy implementations.
- Prefer a clean breaking release over preserving outdated behavior. Update the interface, README and release metadata together, and let consumers remain on an older immutable module tag until they migrate.
- When an upstream platform announces retirement, adapt before the retirement date and remove the retired option from the module interface.

## Breaking Changes

Adding a required variable, renaming a resource, or removing a resource from a module is a breaking change for every consumer.

- Publish breaking changes as a new major release without in-module compatibility shims. Consumers migrate explicitly when they choose to update their pinned module tag.
- Document any state migration command consumers must run before applying the new major release.
- Tag a release and require callers to pin to it. A caller tracking a branch ref inherits breaking changes silently on their next `init`.
- Record the change in the commit message with a `BREAKING CHANGE:` footer.

## Release References

- Keep the module source example in `README.md` pinned to the immutable tag expected from the current change, not `main` or the previous release.
- Before a pull request is merged, derive the expected final tag from the release workflow's numeric major, minor and patch outputs, excluding any feature-branch pre-release suffix, and update the README in the same change.
- Treat a mismatch between the README source ref and the expected final release tag as a CI failure.

## Dead Code

Delete superseded and dormant configuration outright; Git holds the history. Do not retain commented-out blocks for possible future use.
