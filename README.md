# Laravel Docker Template with CI/CD

A ready-to-use **Laravel Docker template** with **GitHub Actions** and **GitLab CI/CD** deployment setup for automatic deployment to your VPS.

This template includes:

* Dockerized Laravel setup (PHP-FPM, Nginx, Postgres, Redis).
* Separate `docker-compose` files for **development** and **production**.
* Ready-to-use **CI/CD files** for GitHub and GitLab.
* Laravel optimization commands (cache, route, view) and migrations during deploy.

---

## 📂 Folder Structure

```
.
├── docker
│   ├── cache
│   ├── database
│   ├── php
│   └── webserver
├── docker-compose.dev.yml
├── docker-compose.prod.yml
├── docker-compose.override.yml
├── docker-compose.yml
├── github-ci-deploy.yml.txt       # GitHub Actions CI/CD
├── gitlab.ci.yml.text             # GitLab CI/CD
├── LICENSE
└── README.md
```

---

## ⚙️ How to Use

1. **Copy CI/CD files**
   Copy `github-ci-deploy.yml.txt` → `.github/workflows/deploy.yml`
   Copy `gitlab.ci.yml.text` → `.gitlab-ci.yml`

2. **Update CI/CD names and paths**

   * Change `deploy.yml` or `.gitlab-ci.yml` job names if needed.
   * Update project path on VPS (`/var/www/laravel-app`) in scripts.

3. **Set secrets / variables**

   **GitHub Actions**:

   * `VPS_HOST` → VPS IP
   * `VPS_USER` → SSH username
   * `VPS_SSH_KEY` → Private SSH key (public key in `~/.ssh/authorized_keys`)

   **GitLab CI/CD**:

   * `VPS_HOST` → VPS IP
   * `VPS_USER` → SSH username
   * `VPS_SSH_KEY` → Private SSH key

4. **Optional**: Add a production `.env.docker` file on VPS.

5. **Push to main branch**

   * CI/CD will automatically deploy your latest Laravel code to VPS, rebuild Docker containers, run migrations, and optimize Laravel cache.

---

## 🔹 Recommended Commands for VPS

```bash
cd /var/www/laravel-app
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
docker compose exec php-fpm php artisan migrate --force
docker compose exec php-fpm php artisan config:cache
docker compose exec php-fpm php artisan route:cache
docker compose exec php-fpm php artisan view:cache
```

---

## ⚡ Notes

* Use `docker-compose.prod.yml` for production deployments.



