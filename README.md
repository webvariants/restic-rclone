# restic/rclone backup client/server

```bash

# steps to run on server (backup target)

# build image
./bin/build-image

# create certs directory with right permissions
./bin/fix-permission

# create configuration for host
./bin/add-host
# follow interactive steps
# you need a server with domain name and open ports

NAME=... # use name from interactive steps

# run server
./bin/restic-host-server $NAME

# follow https://restic.net/#installation

# init repository
./bin/restic-host $NAME init

# copy needed files to client (host with files to backup)
./bin/tar-host-client $NAME
scp $NAME.tar.gz YOUR-HOST:
ssh YOUR-HOST
tar xzvf $NAME.tar.gz

# follow https://restic.net/#installation

# test connection
./bin/restic-host $NAME snapshots
```
