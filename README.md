# GCE, GAE and GKE deployment

## Prepare your code

Here is a quick steps to prepare a demo web and can be run on a Linux machine...

Create a node.js express web...

```
# cd /opt
# npm install express-generator -g
# express web
# cd web && npm install
```

Set service run on boot

```
# vi /etc/init.d/start
```

/etc/init.d/start content...

```
#!/bin/bash
cd /opt/web
npm start
```

set permission for the start script...

```
chmod u+x /etc/init.d/start
```

Set to run level...

```
# cd /etc/rc5.d
# ln -s /etc/init.d/start S05start
```

## Deploy

* [GCE deploy](GCE.md)
* [GAE deploy](GAE.md)
* [GKE deploy](GKE.md)

## PPT & Video

* PPT: http://www.slideshare.net/peihsinsu/google-cloud-computing-compares-gce-gae-and-gke
* Video: http://youtu.be/dsJLqQ-zets