# Contained

## Example

**config/deploy.yml**

```yaml
stack: example

environments:
  production: hosts
    - 1.2.3.4
    - 5.6.7.8
  test: hosts
    - 4.3.2.1
    - 8.7.6.5

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

```bash
gem install contained
```

```bash
contained setup
```

## Usage

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
