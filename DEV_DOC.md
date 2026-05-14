# Developer Documentation - Inception

## Prerequisites

- Docker & Docker Compose
- Make
- Linux/macOS (or WSL2 on Windows)
- Root/sudo access (for volume mounts)

## Project Structure

```
.
├── srcs/
│   ├── docker-compose.yml
│   └── requirements/
│       ├── nginx/
│       │   ├── Dockerfile
│       │   └── conf/
│       ├── wordpress/
│       │   ├── Dockerfile
│       │   └── tools/
│       └── mariadb/
│           ├── Dockerfile
│           └── tools/
├── secrets/
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
├── Makefile
└── README.md
```

## Environment Setup

### 1. Prerequisites Configuration

Create `.env` file in `srcs/` (sourced by docker-compose.yml):

```bash
USER_LOGIN=$(whoami)
```

### 2. Secrets Setup

Create three files in `secrets/`:

**`secrets/credentials.txt`** (WordPress admin)
```
wordpress_user=admin
wordpress_password=your_password
wordpress_email=admin@example.com
```

**`secrets/db_password.txt`** (MariaDB user)
```
your_db_password
```

**`secrets/db_root_password.txt`** (MariaDB root)
```
your_root_password
```

### 3. Data Directories

Automatically created by Makefile:
```
/home/$(USER)/data/
├── mariadb/
└── wordpress/
```

## Build & Launch

### Quick Start
```bash
make up
```

Creates directories, builds images, starts all containers in background.

### Makefile Commands

| Command | Action |
|---------|--------|
| `make up` | Build & start all services |
| `make down` | Stop & remove containers |
| `make stop` | Pause containers (keeps data) |
| `make start` | Resume containers |
| `make status` | Show container states |
| `make logs` | Stream logs (Ctrl+C to exit) |
| `make clean` | Remove containers & volumes |
| `make fclean` | Full cleanup (removes data) |
| `make re` | Full restart (fclean + up) |

## Container Management

### Docker Compose Direct Commands

```bash
# View running containers
docker compose -f srcs/docker-compose.yml ps

# Execute command in container
docker compose -f srcs/docker-compose.yml exec mariadb mysql -u root -p
```

### Volume Management

```bash
# List volumes
docker volume ls

# Inspect volume (shows mount path)
docker volume inspect inception_mariadb_data
```

## Data Persistence

### Volume Configuration (docker-compose.yml)

```yaml
volumes:
  mariadb_data:
    driver: local
    driver_opts:
      type: none
      device: /home/${USER_LOGIN}/data/mariadb
      o: bind
  wordpress_data:
    driver: local
    driver_opts:
      type: none
      device: /home/${USER_LOGIN}/data/wordpress
      o: bind
```

**Bind Mounts** connect host directories to container paths:
- MariaDB: `/home/$(USER)/data/mariadb` ↔ `/var/lib/mysql`
- WordPress: `/home/$(USER)/data/wordpress` ↔ `/var/www/html/wordpress`

### Data Location

```
Host:      /home/$(USER)/data/
Container: /var/lib/mysql (MariaDB)
Container: /var/www/html/wordpress (WordPress)
```

Data survives:
- ✅ Container restart (`make stop` / `make start`)
- ✅ Container removal (`make down`)
- ❌ Volume deletion (`make clean`)
- ❌ Full cleanup (`make fclean`)

## Network Architecture

**Network**: `inception` (bridge)
- MariaDB: internal only (port 3306)
- WordPress: internal only (port 9000, PHP-FPM)
- NGINX: external (port 443 on host)

Services communicate via internal network; only NGINX exposed.

## Build Details

### Custom Dockerfile Locations

- `srcs/requirements/nginx/Dockerfile`
- `srcs/requirements/wordpress/Dockerfile`
- `srcs/requirements/mariadb/Dockerfile`

### Init Scripts (Idempotent)

Located in `srcs/requirements/[service]/tools/`:
- `mariadb.sh` - Database initialization
- `wp_config.sh` - WordPress configuration
- `www.conf` - PHP-FPM pool configuration

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Image build fails | Check Dockerfile syntax, rebuild with `make re` |
| Port 443 conflict | Change port in docker-compose.yml or stop blocking service |
| Data permission denied | Ensure `/home/$(USER)/data/` is writable by your user |
| Container won't start | Check logs: `make logs` |
| .env not found | Create `.env` in `srcs/` with `USER_LOGIN=$(whoami)` |
| Volumes not mounting | Verify paths exist and permissions are correct |

## Development Workflow

1. **Setup**: Create secrets and `.env` in `srcs/`
2. **Build**: `make up` to build and launch
3. **Develop**: Edit Dockerfiles in `srcs/requirements/[service]/`
4. **Test**: Rebuild with `make re` for clean rebuild
5. **Debug**: Check `make logs` and container exec
6. **Cleanup**: `make fclean` removes all (full reset)

---

See [README.md](README.md) for project overview and [USER_DOC.md](USER_DOC.md) for end-user guide.
