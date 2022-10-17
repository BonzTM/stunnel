# stunnel

## About
This container is incredibly simple.  It's meant to sit, listen, and proxy connections with no additional configuration.

If the configuration is too simple (or you want to have multiple services), you can build and publish a custom container image.

Here is the `stunnel.conf` that is generated at runtime

## Source
https://github.com/BonzTM/stunnel

```conf
foreground = yes
setuid = stunnel
setgid = stunnel
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
cert = /etc/stunnel/stunnel.pem
client = ${CLIENT:-no}

[${SERVICE}]
accept = ${ACCEPT}
connect = ${CONNECT}
```
*stunnel.pem self-signed and generated at boot*

## Environment Variables

```sh
- CLIENT: yes
- SERVICE: <any_name>
- ACCEPT: 0.0.0.0:<port>
- CONNECT: <url:port>
```

## Examples

### Docker run
```sh
docker run -d \
        -e CLIENT=yes \
        -e SERVICE=astraweb \
        -e ACCEPT=0.0.0.0:80 \
        -e CONNECT=news.astraweb.com:443 \
        -p 80:80
```
*Then in your client, you simply point to http:containerip:80*

### Kubernetes

**Deployment**
```yaml
---
kind: Deployment
apiVersion: apps/v1
metadata:
  name: stunnel
  namespace: stunnel
  labels:
    app: stunnel
spec:
  replicas: 1
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      app: stunnel
  template:
    metadata:
      labels:
        app: stunnel
    spec:
      containers:
        - name: stunnel
          image: bonztm/stunnel:latest
          ports:
            - containerPort: 80
          env:
            - name: CLIENT
              value: "yes"
            - name: SERVICE
              value: "astraweb"
            - name: ACCEPT
              value: 0.0.0.0:80
            - name: CONNECT
              value: "news.astraweb.com:443"
```

**Example service** \
*If you are in-cluster, you can point your client to servicename-namespace.svc.cluster.local*
```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: stunnel
  namespace: stunnel
  labels:
    app: stunnel
spec:
  ports:
    - port: 80
      name: stunnel
  selector:
    app: stunnel
```

**Example service w/ Nodeport** \
*If you use stunnel out-of-cluster, you can use nodeports and just specify clusterip:port*
```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: stunnel
  namespace: stunnel
  labels:
    app: stunnel
spec:
  type: NodePort
  ports:
    - port: 37000
      nodePort: 37000
      name: stunnel-port
      targetPort: 80
      protocol: TCP
  selector:
    app: stunnel
```

