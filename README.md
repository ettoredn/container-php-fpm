# Production-ready PHP-FPM Docker Image

- FPM exposed via unix socket in bind mount
- php app mounted via bind mount
- composer executable via `docker exec <instance> composer`
- CLI executable via `docker exec <instance> php`

## Included modules
- GD with WebP, PNG, JPEG
- EXIF
- sodium
- APCu
...

## Environment variables
Should be set via .env for symfony projects. For WP, config is set from the mounted app root.

