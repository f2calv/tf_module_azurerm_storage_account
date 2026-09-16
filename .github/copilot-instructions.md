# Copilot Instructions

<!-- ── Synced section ─────────────────────────────────────────────────────
     This file plus every file under `.github/instructions/` is kept
     identical across all f2calv Terraform module repositories. The
     repo-specific "Project-Specific Overrides" section below is excluded
     from sync. Edit once, sync everywhere.
     ──────────────────────────────────────────────────────────────────── -->

## Instruction Files

Detailed conventions live in scoped instruction files under `.github/instructions/`, auto-applied by file type:

| File | Applies to | Covers |
| --- | --- | --- |
| [`terraform.instructions.md`](instructions/terraform.instructions.md) | `**/*.tf`, `**/*.tfvars`, `**/*.hcl` | Formatting, version constraints, module versioning, variables, outputs, security |
| [`github.instructions.md`](instructions/github.instructions.md) | `**` | Forward-only maintenance, branch naming, pull requests, continuous integration, dependency automation |
| [`documentation.instructions.md`](instructions/documentation.instructions.md) | `**/*.md` | README consistency and Mermaid diagrams |

Every file under `.github/instructions/` is byte-identical across the Terraform module repositories. Never edit one in isolation — apply the change to all of them, or do not make it here. Repo-specific rules belong in the "Project-Specific Overrides" section below.

The conventions below always apply, regardless of the file being edited.

## Copilot Workflow

- **Terraform execution**: `terraform fmt`, `terraform validate` and a backend-free `terraform init` are safe to run unprompted. Always prompt (ideally with a visual yes/no button) before any command that authenticates to Azure, reads remote state or mutates infrastructure, including `plan`, `apply`, `destroy` and `import`.
- **Linting without local tooling**: This repository assumes no linters are installed on the host. Run `tflint`, `trivy` and `shellcheck` from their official containers, and `markdownlint` through `npx`.
- **Preserve git history during renames/moves**: When renaming or relocating files, first perform the rename/move (preferably via `git mv`), then make content edits to the file in its new location/name. This two-step approach preserves git history across the rename. Do not delete-and-recreate files when a rename or move is the intent.
- **Multi-repo commits**: When a single change spans multiple repositories, separate per-repository commit messages are acceptable (but not mandatory). Prefer them where the changes are disconnected, or where one repository should not really "know about" the other. A single shared commit message is fine when the change is genuinely coupled.
- **Commit messages**: Plain text only. Use a conventional-commit type and scope followed by terse imperative bullets. Never add a decorative or sign-off footer, never claim AI authorship, and never use emojis or icons in a subject or body.

## Public Repository Confidentiality

- Treat every non-public repository's identity and contents as confidential, even when they appear in the local workspace, conversation context, diffs, logs, or tool output.
- Never publish private repository names, URLs, owner/repository coordinates, branches, file paths, architecture, deployment details, or inferred existence in tracked files, commit messages, issues, pull request titles/descriptions/reviews/comments, release notes, workflow annotations, examples, or other public-facing content.
- Describe required relationships generically (for example, "private GitOps repository" or "internal service") and supply private coordinates only through secrets, repository variables, or caller-provided values.
- Before creating or updating public GitHub content, review the proposed text and metadata for private identifiers and implementation details.
- Never commit a real subscription, tenant, object or resource identifier, hostname, IP address or account name. Use documentation placeholders such as `00000000-0000-0000-0000-000000000000` and `example.com`.

## Repository Structure

Every f2calv Terraform module repository follows the same layout:

- **Root files**: `README.md`, `LICENSE`, `GitVersion.yml`, `.gitattributes`, `.gitignore`, `.pre-commit-config.yaml` and `.terraform-docs.yml`.
- **Module source** lives under `src/` as `main.tf`, `variables.tf`, `outputs.tf` and `versions.tf`. The module declares no backend and no provider configuration — both belong to the calling root module.
- **Tooling** lives in dot-prefixed folders — `.github/` (workflows, instructions, Dependabot), `.devcontainer/`.
- **Additional documentation** beyond the root `README.md` lives as Markdown under `docs/`.
- **`.gitattributes`** standardises line endings across Windows/Linux. Use:

  ```gitattributes
  * text=auto eol=lf
  *.{cmd,[cC][mM][dD]} text eol=crlf
  *.{bat,[bB][aA][tT]} text eol=crlf
  ```

- **`GitVersion.yml`** in the root drives semantic-versioning rules.

## Misc

- When detecting new conventions or patterns, add them to the appropriate `.github/instructions/*.instructions.md` file (or this file for cross-cutting workflow rules) and apply them retroactively across every module repository.
- Keep this file and the `.github/instructions/` files in sync across repositories based on the common synced guidelines.

---

## Project-Specific Overrides

<!-- This section is excluded from cross-repository sync. Place any repo-specific rules below. -->

### Repository Purpose

This repository publishes a single reusable Terraform child module that provisions an Azure storage account together with its containers, file shares and access configuration.
