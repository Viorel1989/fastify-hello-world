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

## Optimizations

- Installed Commitizen as pre-commit hook
- Added editorconfig file for formatting consistentcy

## Acknowledgements

 - [Commitizen tool](https://commitizen-tools.github.io/commitizen/)
