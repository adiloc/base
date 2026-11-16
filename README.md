# 🏠 base

**A production-grade home infrastructure — because the best way to predict the future is to run it at home.**

[![Security Scan](https://github.com/adiloc/base/actions/workflows/security.yml/badge.svg)](https://github.com/adiloc/base/actions/workflows/security.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![YAML Lint](https://github.com/adiloc/base/actions/workflows/validate.yml/badge.svg)](https://github.com/adiloc/base/actions/workflows/validate.yml)

---

## Why this exists

My homelab is where theory meets reality. Every service, every automation, every line of config was born from a real problem I needed to solve — a device that wouldn't integrate, a workflow that was too manual, a security gap I refused to accept. This repo is the blueprint of a system built by someone who cares about the details most people never see.

I don't just run containers. I design architectures, write security policies, create custom hardware components, and automate everything I can touch. This is infrastructure engineering, not a Docker Compose collection.

---

## Architecture

```
                   ┌─────────────────────────────────────────┐
                   │              Your Home                  │
                   │                                         │
  ┌──────────┐     │  ┌──────────┐   ┌───────────┐           │
  │ WireGuard│─────┼─▶│  Caddy   │◀──│  Dnsmasq  │           │
  │   VPN    │     │  │  Reverse │   │   DNS +   │           │
  └──────────┘     │  │  Proxy   │   │   DHCP    │           │
                   │  │  HTTPS   │   └───────────┘           │
                   │  └──────────┘            │              │
                   │           │  ┌───────────────────────┐  │
                   │           ├──│    Apps & Services    │  │
                   │           │  │                       │  │
                   │  ┌────────┼──│  Homepage (Dashboard) │  │
                   │  │        │  │  Wallabag (Read-Later)│  │
                   │  │  Home  │  │  Planka (Kanban)      │  │
                   │  │  Assistant│  Linkding (Bookmarks) │  │
                   │  │  Hub   │  └───────────────────────┘  │
                   │  └────────┘                             │
                   │  ┌─────────────────────┐    ┌──────────┐│
                   │  │  Automation Layer   │    │Monitoring││
                   │  │                     │    │          ││
                   │  │  Mosquitto (MQTT)   │◀───│ Uptime   ││
                   │  │  Zigbee2MQTT        │    │  Kuma    ││
                   │  │  ESPHome (IoT)      │    └──────────┘│
                   │  │  Home Assistant     │                │
                   │  └─────────────────────┘                │
                   │  ┌─────────────────────┐                │
                   │  │  Storage & Data     │                │
                   │  │                     │                │
                   │  │  MinIO (S3)         │                │
                   │  │  PostgreSQL         │                │
                   │  │  Radicale (CalDAV)  │                │
                   │  └─────────────────────┘                │
                   └─────────────────────────────────────────┘
```

---

## What's running

### 🌐 Network & Security

| Service | Port | Why It Matters |
|---------|------|----------------|
| **Caddy** | 80, 443 | Zero-config HTTPS with automatic certificates. Every service is encrypted. |
| **Dnsmasq** | 53 | Local DNS + DHCP. Every device gets a predictable address and resolvable name. |
| **WireGuard** | 51820 | Minimal, fast VPN. Access from anywhere, zero trust compromises. |

### 🏠 Home Automation

| Service | Purpose | The Cool Part |
|---------|---------|---------------|
| **Home Assistant** | The brain. Orchestrates everything. | 1,000+ device integrations, custom blueprints, automations that work. |
| **ESPHome** | IoT firmware | Custom components — including my own `aip33628` display driver. |
| **Mosquitto** | MQTT broker | The message backbone. Every sensor and switch flows through here. |
| **Zigbee2MQTT** | Zigbee ↔ MQTT bridge | One coordinator, dozens of devices, zero vendor lock-in. |

### 💾 Infrastructure

| Service | Purpose |
|---------|---------|
| **MinIO** | S3-compatible object storage |
| **PostgreSQL** | Structured data persistence |
| **Radicale** | CalDAV/CardDAV — my contacts and calendar, on my terms |

### 📊 Applications

| Service | Purpose |
|---------|---------|
| **Homepage** | Dashboard for all services |
| **Wallabag** | Self-hosted read-it-later |
| **Planka** | Kanban boards |
| **Linkding** | Minimal bookmark manager |

### 🔍 Monitoring

| Service | Purpose |
|---------|---------|
| **Uptime Kuma** | Health checks, alerts, status pages |

---

## Engineering beyond Docker

A homelab isn't impressive because of what you run. It's impressive by how you run it.

### 🔐 Security-First

- **Gitleaks** — Secret scanning on every commit and weekly scheduled runs
- **Trivy** — Configuration vulnerability scanning in CI/CD
- **Threat model** documented in `docs/security/threat-model.md`
- **Secrets** never touch the repo. Mounted via bind volume at runtime only
- **Network isolation** — Services only talk to what they need
- **No anonymous access** — MQTT requires auth, all traffic behind Caddy

### 🧪 Development Workflow

```bash
make validate    # lint YAML, shellcheck, gitleaks
make test        # pytest unit, integration, and acceptance tests
make dev-up      # spin up with dev overrides
make dev-down    # clean teardown
```

Three environments, zero copy-paste: **development**, **staging**, **production**. Each with its own compose overrides, environment examples, and documented runbooks.

### 📦 Reproducible & Portable

Everything is declarative. `git clone`, fill in your secrets, `docker compose up`. No manual setup, no "works on my machine" energy.

---

## Project structure

```
├── apps/                  # User-facing services
│   ├── homepage/
│   ├── wallabag/
│   ├── planka/
│   └── linkding/
├── automation/            # Smart home & IoT
│   ├── homeassistant/     # HA core + automations + blueprints
│   ├── esphome/           # IoT firmware + custom components
│   ├── mosquitto/         # MQTT broker
│   └── zigbee2mqtt/       # Zigbee bridge
├── network/               # Networking layer
│   ├── caddy/             # Reverse proxy + HTTPS
│   ├── dnsmasq/           # DNS + DHCP
│   └── wireguard/         # VPN
├── infrastructure/        # Data layer
│   ├── minio/             # S3 storage
│   ├── postgres/          # PostgreSQL
│   └── radicale/          # CalDAV/CardDAV
├── monitoring/            # Health & uptime
│   └── uptime-kuma/
├── environments/          # Per-environment config
│   ├── development/
│   ├── staging/
│   └── production/
├── scripts/               # Deploy, backup, rollback, healthcheck
├── tests/                 # Unit, integration, acceptance
├── docs/                  # Architecture, ops, security
└── .github/workflows/     # CI/CD pipelines
```

---

## Tech stack

| Layer | Tools |
|-------|-------|
| **Orchestration** | Docker Compose |
| **Home Automation** | Home Assistant, ESPHome, Zigbee2MQTT, Tasmoadmin |
| **Messaging** | Mosquitto (MQTT) |
| **Networking** | Caddy, Dnsmasq, WireGuard |
| **Storage** | MinIO (S3), PostgreSQL, Radicale |
| **Monitoring** | Uptime Kuma |
| **CI/CD** | GitHub Actions, Gitleaks, Trivy, yamllint, shellcheck |
| **Infrastructure** | Pure Docker, zero proprietary cloud |

---

## Getting started

This repo is the config layer. You'll need:

1. **A machine** — Raspberry Pi 4 or any x86_64 server
2. **Docker + Docker Compose**
3. **Your secrets** — create a `secrets/` directory following `.env.example`
4. **One Zigbee coordinator** (optional, for full smart home)

```bash
# Clone, configure, go
git clone https://github.com/adiloc/base.git
cd base
cp .env.example .env    # fill in your values
make dev-up
```

Full setup guide: `docs/architecture/overview.md`

---

## Security

I take this seriously — because a home is personal.

| Practice | Details |
|----------|---------|
| Secret scanning | Gitleaks on every PR + weekly cron |
| Config scanning | Trivy detects HIGH/CRITICAL issues |
| YAML quality | yamllint enforces consistency |
| Shell safety | shellcheck on all scripts |
| Threat model | Documented in `docs/security/threat-model.md` |
| Network isolation | Services segmented, no broadcast exposure |

See `docs/security/` for full documentation.

---

## Contributing

This repo is primarily a personal project, but everything is MIT-licensed and open to all.

If you find something useful — a custom ESPHome component, a useful automation, a better config — fork it and make it yours. That's what this is for.

---

## License

MIT — see [LICENSE](LICENSE)

---

*Infrastructure engineering done right: **secure, automated, documented, and actually useful.** Because the things that run your life deserve more than good enough.*
