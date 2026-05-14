# User Documentation - Inception

## Overview

Inception is a Docker-based stack with three services:

- **NGINX** (Port 443): Reverse proxy with TLS/SSL
- **WordPress**: CMS application (Port 9000 internally)
- **MariaDB**: Database (Port 3306 internally)

## Start & Stop

```bash
make up       # Start all services
make stop     # Stop (keeps data)
make start    # Restart
make down     # Stop and remove containers
make clean    # Remove everything (deletes data)
make re       # Full restart
```

## Access

- **Website**: https://tlorette.42.fr
- **Admin Panel**: https://tlorette.42.fr/wp-admin
- **Credentials**: See `secrets/credentials.txt`

*(SSL cert is self-signed; ignore browser warnings)*

## Credentials

All passwords stored in `secrets/`:
- `credentials.txt` - WordPress admin login
- `db_password.txt` - MariaDB user password
- `db_root_password.txt` - MariaDB root password
all are empty but if i want i have them.

**Keep these secure and don't commit to Git.**

## Health Check

```bash
make status   # View all containers
make logs     # See live logs (Ctrl+C to exit)
curl -k https://localhost  # Test NGINX
```

All containers should show **"Up"**.

## Data Location

Persistent data stored in:
```
/home/$(USER)/data/
├── mariadb/
└── wordpress/
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Port 443 in use | Stop blocking service or change port |
| Connection refused | Run `make status` to verify containers are running |
| WordPress not loading | Check logs with `make logs` |
| Data lost | Don't run `make clean` or `make fclean` unless intended |
