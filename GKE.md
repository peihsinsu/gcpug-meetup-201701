# GKE deployment

## Create GKE cluster

```
gcloud container clusters create "demo" \
  --zone "asia-east1-b" \
  --machine-type "n1-standard-1" \
  --image-type "GCI" \
  --disk-size "100" \
  --num-nodes "3" \
  --network "default" \
  --enable-cloud-logging \
  --enable-cloud-monitoring
```

## Connect to your cluster

```
gcloud container clusters get-credentials demo \
    --zone asia-east1-b --project sunny-573
```

## Containerize

You need to containerize your project into docker...

File: Dockerfile

```
From node

ADD ./web /app
WORKDIR /app

CMD ["npm","start"]
```

(put the Docker file with the web folder)

```
docker build -t peihsinsu/simpleweb .
docker push peihsinsu/simpleweb
```

PS: Please change the image path to your own path...

## Prepare deployment file

### Deployment & Service

```
apiVersion: v1
kind: Service
metadata:
  name: web-server
  labels:
    app: web-server
    tier: web-server
spec:
  ports:
  - port: 3000
    targetPort: 3000
  type: LoadBalancer
  selector:
    app: web-server
    tier: web-server
  sessionAffinity: ClientIP
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: web-server
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: web-server
        tier: web-server
    spec:
      containers:
      - name: web-server
        image: peihsinsu/simpleweb
        ports:
        - containerPort: 3000
        env:
        - name: PORT
          value: "3000"
        - name: NODE_ENV
          value: production
        - name: GET_HOSTS_FROM
          value: dns
```

Create service...

```
cd $project/gke-service
kubectl create -f deploy.yaml
```

### Ingress 

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: web-server-ingress
spec:
  backend:
    serviceName: web-server
    servicePort: 3000
```

Create ingress...

```
cd $project/gke-ingress
kubectl create -f ingress.yaml
```

## Check resource status

```
# kubectl get pods,svc,deploy,ingress
NAME                             READY     STATUS    RESTARTS   AGE
po/web-server-2122783915-h3byb   1/1       Running   0          3h

NAME             CLUSTER-IP       EXTERNAL-IP       PORT(S)          AGE
svc/kubernetes   10.247.240.1     <none>            443/TCP          14h
svc/web-server   10.247.242.206   104.199.204.134   3000:31682/TCP   3h

NAME                DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/web-server   1         1         1            1           3h

NAME                     HOSTS     ADDRESS          PORTS     AGE
ing/web-server-ingress   *         130.211.17.179   80        3m
```

## Verify 

Check Service(NLB) address...

```
# curl 104.199.204.134:3000
<!DOCTYPE html><html><head><title>Express</title><link rel="stylesheet" href="/stylesheets/style.css"></head><body><h1>Express</h1><p>Welcome to Express</p></body></html>
```

Check Ingress(HLB) address...

```
# curl 130.211.17.179
<!DOCTYPE html><html><head><title>Express</title><link rel="stylesheet" href="/stylesheets/style.css"></head><body><h1>Express</h1><p>Welcome to Express</p></body></html>
```
