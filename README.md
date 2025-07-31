# Contained

[![LICENSE](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/ksylvest/contained/blob/main/LICENSE)
[![RubyGems](https://img.shields.io/gem/v/contained)](https://rubygems.org/gems/contained)
[![GitHub](https://img.shields.io/badge/github-repo-blue.svg)](https://github.com/ksylvest/contained)
[![Yard](https://img.shields.io/badge/docs-site-blue.svg)](https://contained.ksylvest.com)
[![CircleCI](https://img.shields.io/circleci/build/github/ksylvest/contained)](https://circleci.com/gh/ksylvest/contained)

Deploy using [Docker Swarm](https://docs.docker.com/engine/swarm/) via SSH across multiple and environments.

## Installation

```bash
gem install contained
```

## Commands

### Init

The `contained init` command copies / pastes the following into your project:

```bash
contained init
```

**config/deploy.yml**

```yaml
stack: example

environments:
  production:
    hosts:
      - 1.2.3.4
      - 5.6.7.8
  test:
    hosts:
      - 4.3.2.1
      - 8.7.6.5
```

**config/deploy/compose.yml**

```yaml
config:
  services:
    caddy:
      image: demo/caddy
      ports:
        - "80:80"
      volumes:
        - caddy_data:/data
        - caddy_config:/config
      healthcheck:
        test: ["CMD", "curl", "-f", "http://localhost:80/up"]
        interval: 30s
        timeout: 10s
        retries: 3
    backend:
      build: demo/backend
      healthcheck:
        test: ["CMD", "curl", "-f", "http://localhost:3000/up"]
        interval: 30s
        timeout: 10s
        retries: 3
    frontend:
      build: demo/frontend
      healthcheck:
        test: ["CMD", "curl", "-f", "http://localhost:3000/up"]
        interval: 30s
        timeout: 10s
        retries: 3
  volumes:
    caddy_data:
    caddy_config:
```

### Setup

The `contained setup` command connects to all the hosts within an environment via SSH and configures docker swarm using a stack defined in the **config/deploy/compose.yml** file.

```bash
contained setup --environment production
```

## Examples

### w/ Caddy

**Dockerfile**

```dockerfile
# syntax = docker/dockerfile:1

ARG CADDY_VERSION=2.9.1

FROM docker.io/library/caddy:${CADDY_VERSION}-alpine

COPY Caddyfile /etc/caddy/Caddyfile
```

**Caddyfile**

```caddyfile
demo.com {
  encode

  handle /up {
    respond "OK" 200 {
      close
    }
  }

  handle /backend/up {
    uri replace /backend/ /
    reverse_proxy backend:3000
  }

  handle /frontend/up {
    uri replace /frontend/ /
    reverse_proxy frontend:3000
  }

  handle /api/* {
    reverse_proxy backend:3000
  }

  handle /* {
    reverse_proxy frontend:3000
  }
}
```

### Deploy

The `contained deploy` command connects to all the hosts within an environment via SSH and prunes docker then re-deploys the stack.

```bash
contained deploy --environment production
```
