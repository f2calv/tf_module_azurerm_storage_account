---
description: 'README consistency and Mermaid diagram conventions for Markdown documentation.'
applyTo: '**/*.md'
---

# Documentation

## README Consistency

- Every project's `README.md` must stay in sync with its implementation. During any refactoring — and **always** before creating a new PR — scan the `README.md` for inconsistencies: outdated input/output names, missing or removed configuration options, or inaccurate examples. Update the README as part of the same change, not as a follow-up.
- **Markdown tables**: Table separator rows must use spaces around pipes to match the spaced style used in header and data rows (e.g. `| --- | --- |` not `|---|---|`). This prevents MD060 (table-column-style) warnings.
- **Only document what exists**: Do not describe module behavior until the implementation and validation are in place.
- **Placeholders in examples**: Use synthetic values. Never include real credentials, tokens, connection strings, endpoints, hostnames, resource ids or personal data.

### Structure and Accessibility

- Use exactly one `# H1` as the first content line, naming the module.
- Do not add YAML front matter to a `README.md`; GitHub renders it as a table rather than a document title.
- Never skip heading levels. Use `#`, then `##`, then `###` in order.
- Lead with a one- or two-sentence summary stating what the module provisions and who owns its dependencies.
- Keep the H1 aligned with the repository and module identity.
- Use descriptive link text and meaningful alt text for every image.
- Keep headings unique within each file so generated anchors resolve predictably.

## Mermaid Diagrams

Use Mermaid diagrams in `README.md` files to visualize complex relationships and flows. Choose the appropriate diagram type:

### Diagram Type Selection

- **`flowchart`**: Sequential processes, data flow, event flow, service orchestration, CI/CD pipelines
  - Direction: Use `TD` (top-down) for vertical flows; `LR` (left-right) for wide workflows
  - Example: GitHub Actions workflow chains, composite action steps

- **`graph`**: Relationships, dependencies, hierarchies (non-sequential)
  - Direction: Use `TD` for dependency trees; `LR` for peer relationships
  - Example: Action dependencies, workflow call chains

### Standard Headings

Use these consistent heading patterns before Mermaid diagrams:

| Heading | Use For |
| --- | --- |
| `## Deployment Flow` | CI/CD pipelines, GitHub Actions workflows, action call chains |
| `## Dependency Graph` | Action dependencies, workflow relationships |

### Styling Guidelines

- **Subgraphs**: Group related steps or jobs
- **Custom styling**: Define `classDef` for highlighting owned vs. third-party actions
- **Node shapes**:
  - `[ ]` rectangle (default) - actions, jobs
  - `([ ])` stadium - workflows
  - `{ }` diamond - decision points

### Synchronization

- Mermaid diagrams must stay in sync with action/workflow changes
- When renaming inputs/outputs, update corresponding diagram nodes
- When adding/removing action dependencies, update dependency graphs
- Review all `README.md` diagrams before creating PRs

## Markdown Linting

- Run linting from the repository root so repository configuration is discovered.
- Before pushing, run `npx -y markdownlint-cli --disable MD013 MD034 -- README.md .github/instructions/*.md`.
