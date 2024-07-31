[![Known Vulnerabilities](https://snyk.io/test/github/Viorel1989/fastify-hello-world/badge.svg)](https://snyk.io/test/github/Viorel1989/fastify-hello-world)
[![Coverage Status](https://coveralls.io/repos/Viorel1989/fastify-hello-world/badge.svg)](https://coveralls.io/github/Viorel1989/fastify-hello-world)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)

# Simple REST API based on Fastify framework.

## Run locally

Clone the project

```bash
  git clone https://github.com/Viorel1989/fastify-hello-world.git
```

Go to the project directory

```bash
  cd fastify-hello-world
```

Run npm install to install required depdendencies

```bash
  npm install
```

Start server

```bash
  npm start
```

Requests sent to localhost:3000 will respond with the following json:

```json
{
  "hello": "world"
}
```

## Running Tests

To run tests, run the following command

```bash
  npm run test:unit
```

## Install pre-commit hooks

Before you start, make sure you have the following installed on your machine:

- [Python](https://www.python.org/downloads/) (to use pip)

```bash
  pip install pre-commit
  pre-commit install --hook-type commit-msg
```

## Build Azure Image

Create resource group

```shell
az group create -n fastifyResourceGroup --location westeurope
```

Create service principal

```shell
# !!! Save the content of $AZURE_SECRETS in safe place for long-term storage
AZURE_SECRETS=$(az ad sp create-for-rbac -n "$USER@$(hostname -f)" --role Contributor --scopes /subscriptions/$(az account show --query "{ subscription_id: id }" | jq -r ".subscription_id") --query "{ client_id: appId, client_secret: password, tenant_id: tenant }")
```

Build image

```shell
packer init fastifyVM.pkr.hcl

packer build \
  -var "subscription_id=$(az account show --query "{ subscription_id: id }" | jq -r ".subscription_id")" \
  -var "tenant_id=$(echo $AZURE_SECRETS | jq -r ".tenant_id")" \
  -var "client_id=$(echo $AZURE_SECRETS | jq -r ".client_id")" \
  -var "client_secret=$(echo $AZURE_SECRETS | jq -r ".client_secret")" \
  -var "version=sha-$(git rev-parse --short HEAD)" \
  fastifyVM.pkr.hcl
```

Create VM

```shell
az vm create \
    --resource-group fastifyResourceGroup \
    --name fastify-hello-world \
    --image fastifyVM-sha-$(git rev-parse --short HEAD) \
    --size Standard_B2ats_v2 \
    --admin-username $USER \
    --ssh-key-values ~/.ssh/id_ed25519.pub

az vm open-port \
    --resource-group fastifyResourceGroup \
    --name fastify-hello-world \
    --port 3000

curl $(az vm list-ip-addresses --name fastify-hello-world --resource-group fastifyResourceGroup --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" | jq -r):3000

az resource delete --ids $(az resource list -g fastifyResourceGroup --query "[].id" -o tsv)
```

## Optimizations

- Installed Commitizen as pre-commit hook to ensure Semantic Versioning and Conventional Commits specifications
- Added editorconfig, prettier and eslint for formatting consistentcy
  - (VS Code only) Install VS Code extensions: [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint), [Prettier ESLint](https://marketplace.visualstudio.com/items?itemName=rvest.vs-code-prettier-eslint) and [EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig).

## Acknowledgements

- [Semantic Versioning](https://semver.org/)
- [Commitizen tool](https://commitizen-tools.github.io/commitizen/)
- [Conventional commit standard](https://www.conventionalcommits.org/)
- [Pre-commit documentation](https://pre-commit.com/)
