# 📝 Changelog: v0.1-alpha (Pre-release)

This is the initial pre-release version of the **Laravel Docker Template**. It provides a solid foundation for containerized Laravel applications with a focus on flexibility and CI/CD readiness.

## 🚀 Initial Features

### 🏗 Architecture & Docker

* **Dynamic PHP Versioning:** Added support for multi-version PHP builds via folder-based Dockerfiles (e.g., `docker/php/8.4/`).
* **Environment Separation:** Integrated separate `docker-compose.yml` (development) and `docker-compose.prod.yml` (production) configurations.
* **Service Stack:** Pre-configured stack including **PHP 8.4-FPM**, **Nginx (Alpine)**, **PostgreSQL 18**, and **Redis (Alpine)**.
* **Auto-Healing Entrypoint:** Added a custom `entrypoint.sh` that automatically handles storage permissions, directory creation, and Laravel caching.

### 🤖 CI/CD Integration

* **GitHub Actions Workflow:** Added an automated deployment pipeline for VPS via SSH.
* **Smart Deployments:** The CI/CD script now handles local image building, remote image pulling, and database migrations automatically.

### 🛠 Laravel Optimization

* **Healthchecks:** Implemented PostgreSQL healthchecks to ensure the database is ready before PHP starts migrations.
* **Security:** Hardened production configuration by closing internal database and Redis ports to the public.
* **Persistence:** Configured Docker volumes for Database data, Redis data, and Laravel's public storage.

---

## ⚠️ Known Limitations (Alpha)

* **.env Sync:** Users must manually merge `.env.docker` into their primary `.env` file.
* **SSL:** No built-in Let's Encrypt/Certbot automation yet (requires external reverse proxy like Traefik or Nginx Proxy Manager).
* **Container Naming:** Fixed a syntax issue where colons were used in `container_name`.

## 🔧 Installation Summary

1. Clone the repository.
2. Merge `.env.docker` variables into your `.env`.
3. Run `docker compose up -d --build`.
