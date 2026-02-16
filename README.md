# 🚀 Laravel Docker Template with CI/CD

A professional-grade **Laravel Docker template** featuring dynamic PHP versioning, high-performance local development, and a zero-downtime **GitHub Actions** deployment pipeline.

## 📂 Project Structure

```text
.
├── docker
│   ├── php
│   │   └── 8.4             # Versioned PHP environments
│   │       ├── Dockerfile
│   │       ├── entrypoint.sh
│   │       └── php.ini
│   └── webserver
│       └── nginx
│           └── default.conf
├── docker-compose.yml       # Local Development
├── docker-compose.prod.yml  # Production Optimized
├── .github/workflows/       # CI/CD Workflows
└── .env.docker              # <--- IMPORTANT: Docker-specific variables

```

---

## ⚙️ Setup Instructions

### 1. Environment Configuration

Laravel creates a standard `.env` file. To connect Docker and Laravel correctly, you **must** copy the variables from `.env.docker` and append them to your main `.env` file:

```bash
# Append Docker variables to your Laravel .env
cat .env.docker >> .env

```

**Required Variables in `.env`:**

* `PHP_VERSION=8.4` (Matches the folder name in `docker/php/`)
* `PHP_IMAGE_NAME=myapp/php:dev`
* `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`
* `REDIS_PASSWORD`

### 2. Local Development

Start the environment in development mode:

```bash
docker compose up -d --build

```

* **App:** `localhost:8082`
* **Database:** `localhost:6543` (Mapped for GUI tools like TablePlus)

### 3. Production Deployment

The production setup is hardened for security (Database and Redis ports are closed to the public).

**Manual Deploy:**

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build

```

---

## 🤖 CI/CD Deployment (GitHub Actions)

This template includes a pre-configured workflow to deploy your app to a VPS on every push to `main`.

### Prerequisites

1. Set up these **GitHub Secrets**:

* `VPS_HOST`: Your server IP.
* `VPS_USER`: SSH username (e.g., `root` or `ubuntu`).
* `VPS_SSH_KEY`: Your private SSH key.

2. Ensure your VPS project folder matches the path in your workflow file.

### What the CI/CD does

1. Pulls latest code from GitHub.
2. Builds the PHP image locally on the VPS (leveraging Docker cache).
3. Pulls latest Nginx, Postgres, and Redis images.
4. Performs a **near-zero downtime swap** of containers.
5. Automatically runs `php artisan migrate --force`.
6. Optimizes Laravel (Config/Route/View cache).

---

## 🛠 Features

* **Dynamic Versioning:** Change `PHP_VERSION` in `.env` to switch between `8.3`, `8.4`, etc., without touching the YAML.
* **Healthchecks:** The PHP container waits for the Database to be "Healthy" before attempting migrations.
* **Performance:** Uses `:cached` flags for volumes on macOS and optimized PHP-FPM configurations.
* **Security:** Production configuration removes exposed ports for sensitive services.

---

## ⚡ Troubleshooting

**Permission Denied on storage?**
The `entrypoint.sh` automatically attempts to fix permissions at runtime. If issues persist, run:

```bash
docker compose exec php chown -R www-data:www-data /var/www/storage

```

**Database connection refused?**
Ensure your `DB_HOST` in `.env` is set to `database` (the service name), not `127.0.0.1`.