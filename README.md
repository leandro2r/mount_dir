# Mount dir (using sshfs)

### Description

This script was made to easier the process of mounting/umounting many directories even if they are already mounted but not correctly.

You can run it using a `mount_dir.txt` file to get all the directories from it without have to input them in every script calling.

### Requirements

```shell
$ [sudo] apt-get install sshfs
```

### Man mount.sh

```shell
$ ./mount.sh -s <host> -p <host_path> -d <mount_dir>
```

- `-s <host>`: Source host name or IP
- `-p <host_path>`: Host path
- `-d <mount_dir>`: Mount directories
