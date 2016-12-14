PoWA images for docker
======================

This repository contains docker images of PoWA.

The **powa-archivist** contains images for a PostgreSQL cluster with PoWA
installed. All major version supported by PoWA are included.

The **powa-web** directory contains the UI for powa, intended to be used with
one of the **powa-archivist** provided image.

This repository also contains **docker compose files** for each major version
supported by PoWA.  This will automatically setup a powa-web image pointing to
a powa-archivist of the wanted PostgreSQL major version.  UI will be available
with the **postgres** user, no password needed.
