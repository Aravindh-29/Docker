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
