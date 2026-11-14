# 🏠 Homelab

**A production-grade home infrastructure — because the best way to predict the future is to run it at home.**

[![Security Scan](https://github.com/adiloc/homelab/actions/workflows/security.yml/badge.svg)](https://github.com/adiloc/homelab/actions/workflows/security.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![YAML Lint](https://github.com/adiloc/homelab/actions/workflows/validate.yml/badge.svg)](https://github.com/adiloc/homelab/actions/workflows/validate.yml)

---

## Why this exists

My homelab is where theory meets reality. Every service, every automation, every line of config was born from a real problem I needed to solve — a device that wouldn't integrate, a workflow that was too manual, a security gap I refused to accept. This repo is the blueprint of a system built by someone who cares about the details most people never see.

I don't just run containers. I design architectures, write security policies, create custom hardware components, and automate everything I can touch. This is infrastructure engineering, not a Docker Compose collection.

---

## Architecture at a glance

```
                    ┌─────────────────────────────────────────┐
                    │              Your Home                  │
                    │                                         │
  ┌─────────┐      │  ┌──────────┐   ┌───────────┐           │
  │ WireGuard│─────┼─▶│  Caddy   │◀──│  Dnsmasq  │           │
  │   VPN   │      │  │  Reverse │   │   DNS +   │           │
  └─────────┘      │  │  Proxy   │   │   DHCP    │           │
                   │  │  HTTPS   │   └───────────┘           │
                   │  └──────────┘            │               │
                   │           │  ┌─────────────────────┐    │
                   │           ├──│    Apps & Services   │    │
                   │           │  │                     │    │
                   │  ┌────────┼──│  Homepage (Dashboard)│    │
                   │  │        │  │  Wallabag (Read-Later)│    │
                   │  │  Home  │  │  Planka (Kanban)     │    │
                   │  │  Assistant│  Linkding (Bookmarks)│    │
                   │  │  Hub   │  └─────────────────────┘    │
                   │  └────────┘                              │
                   │  ┌─────────────────────┐    ┌──────────┐ │
                   │  │  Automation Layer   │    │Monitoring│ │
                   │  │                     │    │          │ │
                   │  │  Mosquitto (MQTT)   │◀───│ Uptime   │ │
                   │  │  Zigbee2MQTT        │    │  Kuma    │ │
                   │  │  ESPHome (IoT)      │    └──────────┘ │
                   │  │  Home Assistant     │                  │
                   │  └─────────────────────┘                  │
                   │  ┌─────────────────────┐                  │
                   │  │  Storage & Data     │                  │
                   │  │                     │                  │
                   │  │  MinIO (S3)         │                  │
                   │  │  PostgreSQL         │                  │
                   │  │  Radicale (CalDAV)  │                  │
                   │  └─────────────────────┘                  │
                   └─────────────────────────────────────────┘
```

---

## What's running

### 🌐 Network & Security

| Service | Port | Why It Matters |
|---------|------|----------------|
| **Caddy** | 80, 443 | Zero-config HTTPS with automatic certificate management. Your services don't just work — they're *encrypted*. |
| **Dnsmasq** | 53 | Local DNS + DHCP. Every device on your network has a predictable address and a resolvable name. |
| **WireGuard** | 51820 | Miminal, fast VPN. Access your lab from anywhere, with zero trust compromises. |

### 🏠 Home Automation

| Service | Purpose | The Cool Part |
|---------|---------|---------------|
| **Home Assistant** | The brain. Orchestrates everything. | Deep integration with 1,000+ devices, custom blueprints, and automations that actually work. |
| **ESPHome** | IoT device firmware | Custom components (including my own `aip33628` display driver) — I don't just use off-the-shelf firmware. |
| **Mosquitto** | MQTT broker | The message backbone. Every sensor, every switch, every notification flows through here. |
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
| **Homepage** | Beautiful, customizable dashboard for all services |
| **Wallabag** | Read-it-later. Your own Pocket, self-hosted. |
| **Planka** | Kanban boards. Project management without selling your data. |
| **Linkding** | Minimal, fast bookmark manager. |

### 🔍 Monitoring

| Service | Purpose |
|---------|---------|
| **Uptime Kuma** | Health checks, alerts, status pages. If something breaks, I know before you do. |

---

## Engineering beyond Docker

A homelab isn't impressive because of what you run. It's impressive by how you run it.

### 🔐 Security-First by Default

- **Gitleaks** — Automated secret scanning on every commit and weekly scheduled runs
- **Trivy** — Configuration vulnerability scanning in CI/CD
- **Threat model** documented in `docs/security/threat-model.md`
- **Secrets** never touch the repo. Ever. Mounted via bind volume at runtime only
- **Network isolation** — Services only talk to what they need
- **No anonymous access** — MQTT requires auth, every service is behind Caddy

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

1. **A machine** — anything from a Raspberry Pi 4 to a small form-factor PC
2. **Docker + Docker Compose**
3. **Your secrets** — create a `secrets/` directory following the patterns shown in `.env.example`
4. **One Zigbee coordinator** (if you want the full smart home experience)

```bash
# Clone, configure, go
git clone https://github.com/adiloc/homelab.git
cd homelab
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
| Network isolation | Services are segmented, no broadcast exposure |

See `docs/security/` for full documentation.

---

## Contributing

This repo is primarily a personal project, but the code, configs, and documentation are MIT-licensed and open to all.

If you find something useful — a custom ESPHome component, a useful automation, a better config — fork it and make it yours. That's what this is for.

---

## Built with 🔥

Every service in this lab was chosen, configured, and integrated because it solves a real problem. Nothing here is "because it's cool" — even if it is cool.

This is infrastructure engineering done right: **secure, automated, documented, and actually useful.**

---

*Made with obsessive attention to detail. Because the things that run your life deserve more than good enough.*
