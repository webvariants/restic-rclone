# restic/rclone backup client/server

```bash

# steps to run on server (backup target)

# build image
./bin/build-image

# create certs directory with right permissions
./bin/create-certs-dir

# create configuration for host
./bin/add-host
# follow interactive steps
# you need a server with domain name and open ports

NAME=... # use name from interactive steps

# rclone config to setup storage system (https://rclone.org/overview/)
./bin/rclone-config $NAME

# run server
./bin/restic-server $NAME

# follow https://restic.net/#installation

# init repository
./bin/restic-client $NAME init

# copy needed files to client (host with files to backup)
./bin/tar-client $NAME
scp $NAME-client.tar.gz YOUR-HOST:
ssh YOUR-HOST
tar xzvf $NAME-client.tar.gz

# follow https://restic.net/#installation

# test connection
./bin/restic-client $NAME snapshots
```
