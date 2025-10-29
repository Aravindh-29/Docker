# Docker Ports Usage


<img width="1363" height="965" alt="_C__Users_nowsh_Downloads_docker%20Ports drawio%20(1) svg" src="https://github.com/user-attachments/assets/de58f6a8-06bb-489b-aaf4-74560653b09e" />


🔥 Nice — this is **one of the most important fundamentals** in container orchestration.

Let’s break this down **step by step** with practical scenarios, ASCII diagrams, and Docker + Kubernetes mappings 👇

---

## 🧠 Step 1: Basic Port Concepts Refresher

Before we go hands-on:

| Term                   | Meaning                                                                     | Example     |
| ---------------------- | --------------------------------------------------------------------------- | ----------- |
| **Container Port**     | The port inside the container where the app listens.                        | `8080`      |
| **Host Port**          | The port on the host machine that forwards traffic to the container port.   | `80`        |
| **NodePort (K8s)**     | Port opened on every Kubernetes node to expose service outside the cluster. | `30080`     |
| **ClusterIP (K8s)**    | Virtual internal IP accessible only inside cluster.                         | `10.96.0.x` |
| **LoadBalancer (K8s)** | Public IP (through cloud provider) for external access.                     | `35.x.x.x`  |

---

## 🐳 Step 2: Docker Port Mapping (Practical)

Let’s say you have a simple web app inside a container listening on port `8080` internally.

### Command:

```bash
docker run -d -p 80:8080 --name myapp nginx
```

* `80` → Host Port
* `8080` → Container Port
* `nginx` listens on 80 internally, but assume your app listens on 8080 for illustration.

📊 **ASCII Network Flow Diagram**

```
                ┌─────────────────────┐
                │    Client Browser   │
                │ http://localhost:80 │
                └─────────┬───────────┘
                          │
                    Host Machine (Docker Daemon)
                          │  Port 80 (Host)
                          ▼
                ┌────────────────────────┐
                │   Docker NAT Bridge     │
                │  forwards traffic       │
                └─────────┬───────────────┘
                          │
                  Container myapp
                          │ Port 8080
                          ▼
                   Nginx Web Server
```

✅ You access the app from your laptop browser via `http://localhost:80` but internally it hits port 8080 inside the container.

👉 **Two ports here:**

1. Host port (e.g., 80)
2. Container port (e.g., 8080)

---

## 🧱 Step 3: Multiple Containers & Ports (Docker Bridge Network)

Imagine running two different containers:

```bash
docker run -d -p 80:8080 --name web1 nginx
docker run -d -p 81:8080 --name web2 nginx
```

✅ Here:

* Host 80 → web1:8080
* Host 81 → web2:8080

```
       Client
         │
 ┌───────┴────────┐
 │ Host Machine   │
 │80  → web1:8080 │
 │81  → web2:8080 │
 └───────┬────────┘
         │
    Docker Network Bridge
         │
 ┌───────┴─────────┐
 │  web1 container  │
 │ port 8080        │
 └──────────────────┘
 ┌───────┴─────────┐
 │  web2 container  │
 │ port 8080        │
 └──────────────────┘
```

👉 Host port must be **unique**, container ports can be the same.

---

Excellent 🔥 question, Aravindh — this is **one of the most powerful DevOps skills**.
Let’s make you a **Docker Compose master** — you’ll understand what each attribute does, when to use it, and how it helps.

I’ll keep it **simple, structured, and real-world–based** 👇

---

# 🧠 **Docker Compose File?**

A **`docker-compose.yml`** file is used to define and manage **multiple containers** (services) that together form your full application stack — e.g., app + database + cache + message queue.

It’s **Infrastructure-as-Code** for Docker.

---

## ⚙️ **Structure of docker-compose.yml**

```yaml
version: "3.9"

services:
  <service-name>:
    image: ...
    build: ...
    ports: ...
    environment: ...
    volumes: ...
    depends_on: ...
    networks: ...
    restart: ...
    healthcheck: ...
    command: ...
    profiles: ...
    deploy: ...
volumes:
  ...
networks:
  ...
```

Now let’s understand each section deeply 👇

---

## 🧩 **Top-Level Keys**

### 1️⃣ `version`

* Specifies Compose file format (latest = `"3.9"`).
* Helps Docker understand syntax features.

✅ Example:

```yaml
version: "3.9"
```

---

### 2️⃣ `services`

* Defines **each container** in your app.
* Each key under `services:` is one container.

✅ Example:

```yaml
services:
  web:
    image: nginx
  db:
    image: postgres
```

---

## 🚀 **Inside a Service**

### 🧱 `image`

* Pulls a prebuilt image from Docker Hub or registry.

✅ Example:

```yaml
image: redis:alpine
```

💡 Use when:

* You don’t need to build your own image.
* You rely on official/public images.

---

### 🧱 `build`

* Tells Compose to **build your image** using a Dockerfile.

✅ Example:

```yaml
build:
  context: ./app
  dockerfile: Dockerfile
```

💡 Use when:

* You have your own app code and Dockerfile.
* You want to customize builds.

---

### 🌐 `ports`

* Maps **container ports → host ports**.

✅ Example:

```yaml
ports:
  - "8080:80"  # host:container
```

💡 Use when:

* You want to access a web app running inside a container.

---

### 🧩 `environment`

* Sets environment variables inside the container.

✅ Example:

```yaml
environment:
  POSTGRES_USER: admin
  POSTGRES_PASSWORD: secret
```

💡 Use when:

* Passing credentials, API keys, or config options.

---

### 💾 `volumes`

* Mounts data or code between host and container.

✅ Example:

```yaml
volumes:
  - ./app:/usr/src/app
  - db-data:/var/lib/postgresql/data
```

💡 Use when:

* You want persistent storage (e.g., databases).
* You want live code reload in dev.

---

### 🔗 `depends_on`

* Controls **startup order** (container dependencies).

✅ Example:

```yaml
depends_on:
  - db
  - redis
```

💡 Use when:

* One service must start after another (e.g., app → db).

---

### 🌍 `networks`

* Defines communication channels between containers.

✅ Example:

```yaml
networks:
  - front-tier
  - back-tier
```

💡 Use when:

* You want to isolate traffic between groups of containers.

---

### ♻️ `restart`

* Controls container restart behavior.

✅ Example:

```yaml
restart: always
```

Options:

| Policy           | Behavior                        |
| ---------------- | ------------------------------- |
| `no`             | Never restart                   |
| `always`         | Always restart on crash         |
| `unless-stopped` | Restart unless manually stopped |
| `on-failure`     | Restart only if exit code ≠ 0   |

💡 Use when:

* Running in production where reliability matters.

---

### 💓 `healthcheck`

* Tests if a container is healthy.

✅ Example:

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:80"]
  interval: 10s
  timeout: 5s
  retries: 3
```

💡 Use when:

* You need Compose to wait until a service is ready before others start.

---

### 🧮 `command`

* Overrides the default command from Dockerfile’s `CMD`.

✅ Example:

```yaml
command: ["gunicorn", "app:app", "-b", "0.0.0.0:80"]
```

💡 Use when:

* You want to change startup behavior (like running migrations).

---

### 🧰 `profiles`

* Enables **optional** services (run only when requested).

✅ Example:

```yaml
profiles: ["seed"]
```

💡 Use when:

* You have optional containers like testing or seed data.

Run it with:

```bash
docker compose --profile seed up
```

---

### 📦 `deploy`

* Used mainly for **Docker Swarm** (scaling, replicas, etc.)

✅ Example:

```yaml
deploy:
  replicas: 3
  restart_policy:
    condition: on-failure
```

💡 Use when:

* You deploy to Swarm (not used for regular Compose).

---

## 🔒 **Outside Services**

### 💾 `volumes`

* Declares named volumes for persistence.

✅ Example:

```yaml
volumes:
  db-data:
```

💡 Use when:

* You need storage that persists after container deletion.

---

### 🌐 `networks`

* Declares custom networks for communication.

✅ Example:

```yaml
networks:
  front-tier:
  back-tier:
```

💡 Use when:

* You want logical isolation between frontend and backend.

---

## 🧩 **Common Real-World Template**

```yaml
version: "3.9"

services:
  app:
    build: ./app
    ports:
      - "8080:80"
    environment:
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
    depends_on:
      - db
    networks:
      - backend
    restart: always
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:80"]
      interval: 10s
      retries: 3

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend

volumes:
  db-data:

networks:
  backend:
```

---

## ⚡ TL;DR — When to Use What

| Attribute     | Purpose                 | When to Use         |
| ------------- | ----------------------- | ------------------- |
| `image`       | Pull existing container | Using public images |
| `build`       | Build from Dockerfile   | Custom app code     |
| `ports`       | Expose to host          | Web or API apps     |
| `environment` | Pass variables          | Config, secrets     |
| `volumes`     | Persistent or live code | Databases, dev apps |
| `depends_on`  | Start order             | App → DB sequence   |
| `networks`    | Isolate traffic         | Frontend/backend    |
| `restart`     | Auto-restart            | Production          |
| `healthcheck` | Ensure readiness        | Dependent services  |
| `command`     | Override CMD            | Custom startup      |
| `profiles`    | Optional services       | Testing, seed data  |

---

Would you like me to make a **cheat sheet version (visual)** — one-page reference showing attributes, short meanings, and icons — that you can keep as a personal DevOps quick guide?
