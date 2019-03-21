# vnote2codimd: import VNote to CodiMD

## Background

[VNote](https://github.com/tamlok/vnote) is a good markdown note editor and management tool. Sometime I need to share
a note with others, but VNote doesn't support online note sharing currently. There are several approaches for sharing
markdown note, such as directly share `.md` file, share exported `HTML` file, or host a website. But all those
approaches cannot fit my requirements, such as pretty rendering and permission control.

[CodiMD/HackMD](https://github.com/hackmdio/codimd) is a good online markdown note tool. But it doesn't have management
function and good offline desktop client. But it's a good place for sharing some notes when I needed. I can paste or
import the `.md` file to CodiMD or HackMD. However, when there are a lot of figures in my note, it's not that
convenient. Besides, I found that the note in CodiMD or HackMD cannot be totally deleted on their server database. As
CodiMD is open-sourced, so I decided to self-host a CodiMD server. Then I can totally control the shared note.

As I have total control of the self-hosted CodiMD server, so I create this script to import note in VNote to CodiMD. It
will automatically upload figures or attachment files to server and fix the link path in the `.md` file.

## Self-hosted CodiMD instance (Docker container)

Follow instructions in https://github.com/hackmdio/codimd-container.

Modify the `docker-compose.yml` file to set environmental variables. Such as `CMD_DOMAIN`, `CMD_PORT` and
`CMD_URL_ADDPORT`. For importing image files, you must set `CMD_IMAGE_UPLOAD_TYPE=filesystem` and don't change the
default directory (`./public/uploads`). Then start the container:

``` Bash
docker-compose up
```

## Import VNote to CodiMD

The Bash script `importVNote.sh` is built for importing VNote to CodiMD. Some codes are borrowed from
[codimd-cli](https://github.com/hackmdio/codimd-cli).

For server security, it only can be ran on the server. Don't try to access docker container through remote SSH.

Usage example:

``` Bash

```

Parameters:

- 