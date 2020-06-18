# Ghost

[Ghost][ghost-org] is a customizable publishing platform. This is
[Docker][docker] image is custom built for use by GHIFARI160.

## Installation

``` shell
docker run -d --name ghost -p 2368:2368 -v /path/to/persistent/storage:/var/www/ghost ghifari160/ghost
```

## Environment Variables

| Variable          | Description                      | Default Value           |
|-------------------|----------------------------------|-------------------------|
| `GHOST_PORT`      | Port that Ghost should listen on | `2368`                  |
| `GHOST_URL`       | URL of the site                  | `http://localhost:2368` |
| `GHOST_ADMIN_URL` | URL of the admin dashboard       | `http://localhost:2368` |

## Volumes

| Container Storage | Description                                           |
|-------------------|-------------------------------------------------------|
| `/var/www/ghost`  | Persistent storage for Ghost installation and content |

[ghost-org]: https://ghost.org
[docker]: https://docker.com
