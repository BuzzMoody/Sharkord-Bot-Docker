# Sharkord Bot Docker Deployment

This guide explains how to deploy the [Sharkord Bot](https://github.com/BuzzMoody/Sharkord-Bot) using Docker. The image is built on `php:8.5-cli-alpine` and includes all necessary dependencies such as Composer, Git, and the required PHP extensions.

---

## 🛠️ Environment Variables

The bot requires the following environment variables to authenticate and connect to the Sharkord server:

| Variable | Description | Placeholder Value |
| :--- | :--- | :--- |
| `CHAT_USERNAME` | The bot's identity/username | `SharkordBot` |
| `CHAT_PASSWORD` | The bot's account password | `your_secret_password` |
| `CHAT_HOST` | The server hostname | `your.domain.tld` |

---

## 🐳 Option 1: Docker Run

Use this method for a quick, single-container deployment.

```bash
docker run -d \
  --name sharkord-bot \
  --restart always \
  -e CHAT_USERNAME="SharkordBot" \
  -e CHAT_PASSWORD="your_secret_password" \
  -e CHAT_HOST="your.domain.tld" \
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
    volumes:
      - ./:/app
```

### Running with Compose
```bash
# Start the bot in detached mode
docker-compose up -d

# View live logs
docker-compose logs -f
```

---

## 🛠️ Build the Image Manually

If you have modified the source code, rebuild the image locally:

```bash
docker build -t sharkord-bot:latest .
```

---

## 📁 Project Logic Overview

1. **Authentication**: The bot logs in via the provided host to acquire a JWT token.
2. **WebSocket Handshake**: It establishes a JSON-RPC connection using the acquired token.
3. **Caching**: On a successful join, it caches all users and channels into the `Sharkord\\Models` namespace.
4. **Event Loop**: It remains active, listening for `!ping` commands and responding via the `Message` model's `reply()` method.