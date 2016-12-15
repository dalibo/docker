Temboard images for docker
==========================

This folder contains docker images for
[temboard](https://github.com/dalibo/temboard).

A docker-compose file is also provided.  It's aimed to quickly try temboard
with a few postgres servers.

The docker-compose file will launch:

  * a PG 9.4 cluster, configured to also run
    [PoWA](http://dalibo.github.io/powa/)
  * a PG 9.5 cluster, configured to also run
    [PoWA](http://dalibo.github.io/powa/)
  * a PG 9.6 cluster, configured to also run
    [PoWA](http://dalibo.github.io/powa/)
  * a standard PG 9.6 cluster for the UI
  * a container for the UI

After starting the docker-compose image, the UI is available on

https://0.0.0.0:8888

With admin // admin credentials.

The PG instances can be used with these users:

  * alice // alice
  * bob // bob

WARNING: After the initial launch of the docker-compose image, you have to stop
and start again the image in order to proceed at the initial configuration.

NOTE: PoWA is mainly used to simulate some activity, there's no UI setup
for this image (yet).
