# gjgjxweb Docker

[搞机工具箱 Web](https://github.com/CzJam/gjgjxweb) 的非官方 Docker 打包仓库。这里不存放上游源码；构建时从 GitHub 下载指定提交，以非 root Nginx 提供静态页面。镜像保留上游及第三方许可证，无需 Node.js、ADB 后端或容器 USB 设备映射。

## 快速开始

直接运行以下命令：

```bash
docker run -d --name gjgjxweb --restart unless-stopped \
  -p 8124:8080 szcq/gjgjxweb:latest
```

本机用 Chrome 或 Edge 打开 <http://localhost:8124>。远程使用 WebUSB 时，需通过 HTTPS 访问。手机 USB 数据线接到运行浏览器的电脑。

## 使用 Docker Compose

在包含 `docker-compose.yaml` 的目录运行（与上面的 `docker run` 二选一）：

```bash
docker compose pull
docker compose up -d
```

## 本地构建

```bash
docker build -t gjgjxweb:local .
docker run --rm -p 8124:8080 gjgjxweb:local
```

无需克隆上游。`Dockerfile` 默认固定一个已验证的上游提交。要构建其他提交，通过 `--build-arg GJGJXWEB_COMMIT=<完整提交 SHA>` 覆盖。镜像标签 `io.gjgjxweb.upstream.commit` 记录对应提交，`org.opencontainers.image.url` 指向该提交的上游源码。

## GitHub Actions 发布

- 默认推送到 Docker Hub 的 `szcq/gjgjxweb`，支持 `linux/amd64` 和 `linux/arm64`。首次发布前，在 GitHub 仓库配置拥有目标 Docker Hub 仓库写权限的 `DOCKER_TOKEN`，然后在默认分支手动运行 **Build and Push Docker Image**，保留输入 `latest`。Fork 使用自己的 Docker Hub 命名空间时，修改 `docker.yaml` 的 `IMAGE_OWNER` 和 Compose 的镜像地址。
- 输入 `latest` 构建上游默认分支当前提交，发布 `latest` 和 `sha-<完整提交 SHA>`；手动输入完整 SHA 只发布对应 `sha-` 标签，不覆盖 `latest`。
- **Auto Update gjgjxweb** 每日 19:00 UTC 检查一次上游，也可手动运行。若 `latest` 已指向上游当前提交对应的镜像，则跳过构建；打包配置变更后，可手动运行 **Build and Push Docker Image** 重新发布。

## 开源协议

[GPL-3.0-only](LICENSE)
