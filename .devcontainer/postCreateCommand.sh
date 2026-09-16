#!/usr/bin/env bash
#Runs once after the dev container is created.
set -euo pipefail

echo "*****************************************************"
echo "Tool versions"
echo "*****************************************************"
terraform -version
tflint --version
terraform-docs --version

echo
echo "*****************************************************"
echo "Lint this module with:"
echo "*****************************************************"
echo "  terraform-docs --config .terraform-docs.yml src"
echo "  terraform -chdir=src fmt -check -recursive -diff"
echo "  terraform -chdir=src init -backend=false && terraform -chdir=src validate"
echo "  tflint --chdir=src --recursive"
echo "  npx -y markdownlint-cli --disable MD013 MD034 -- README.md .github/instructions/*.md"
