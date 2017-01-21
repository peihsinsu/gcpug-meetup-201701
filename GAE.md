# GAE deployment

## Prepare your project

In GAE, you can add a app.yaml to the project create from [Prepare your code](README.md)...

File: app.yaml

```
runtime: nodejs
env: flex
``

Your project look like:

```
.
|____app.js
|____app.yaml
|____bin
| |____www
|____package.json
|____public
| |____images
| |____javascripts
| |____stylesheets
| | |____style.css
|____routes
| |____index.js
| |____users.js
|____views
| |____error.jade
| |____index.jade
| |____layout.jade
```

## Test

```
npm install && npm start
```

## Deploy to GAE

```
gcloud app deploy -q
```

## Others

Before you use "gcloud app deploy", you should install gcloud and enable "app" component...

```
# curl https://sdk.cloud.google.com | bash
# gcloud auth login
# gcloud components update app
```





