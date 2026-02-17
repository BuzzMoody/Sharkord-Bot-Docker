# Sharkord Bot Docker Deployment

This guide explains how to deploy the [Sharkord Bot](https://github.com/BuzzMoody/Sharkord-Bot) using Docker. The image is built on `php:8.5-cli-alpine` and includes all necessary dependencies such as Composer, Git, and the required PHP extensions.

---

## 🧑‍🏫 Instructions

You must mount the volume where your`Main.php` and `/Commands` directory lives, otherwise the container will fail.

---

## 🛠️ Environment Variables

The bot requires the following environment variables to authenticate and connect to the Sharkord server:

| Variable | Description | Placeholder Value |
| :--- | :--- | :--- |
| `CHAT_USERNAME` | The bot's identity/username | `SharkordBot` |
| `CHAT_PASSWORD` | The bot's account password | `your_secret_password` |
| `CHAT_HOST` | The server hostname | `your.domain.tld` |
| `TZ` | Your local timezone | `Australia/Melbourne` |

---

## 🐳 Option 1: Docker Run

Use this method for a quick, single-container deployment.

```bash
docker run -d \
	--name sharkord-bot \
	--restart always \
	-e TZ="Australia/Melbourne" \
    -e CHAT_USERNAME=USERNAME \
    -e CHAT_PASSWORD=PASSWORD \
    -e CHAT_HOST=your.domain.tld \
    -v "/local/directory:/app" \
	ghcr.io/buzzmoody/sharkord-bot:latest
```

---

## 🏗️ Option 2: Docker Compose

For more manageable deployments, use a `docker-compose.yml` file. This is the recommended method for production.



```yaml
services:
  bot:
    image: ghcr.io/buzzmoody/sharkord-bot:latest
    container_name: sharkord-bot
    restart: always
    environment:
      - CHAT_USERNAME=SharkordBot
      - CHAT_PASSWORD=your_secret_password
      - CHAT_HOST=your.domain.tld
	  - TZ=Australia/Melbourne
    volumes:
      - /local/directory:/app
```