# Calibre Application Setup

Webui can be found at http://your-ip:8083

On the initial setup screen, enter /books as your calibre library location.

Default admin login: Username: admin Password: admin123

If you lock yourself out or forget a password, you will need to specify the app.db similar to this: docker exec -it calibre-web python3 /app/calibre-web/cps.py -p /config/app.db -s <user>:<pass> If you fail to specify the proper db, it will appear to succeed, but it will not work.

## Unrar

Unrar is included by default and needs to be set in the Calibre-Web admin page (Basic Configuration:External Binaries) with a path of /usr/bin/unrar

64bit only We have implemented the optional ability to pull in the dependencies to enable ebook conversion utilising Calibre, this means if you don't require this feature the container isn't uneccessarily bloated but should you require it, it is easily available. This optional layer will be rebuilt automatically on our CI pipeline upon new Calibre releases so you can stay up to date. To use this option add the optional environmental variable as shown in the docker-mods section to pull an addition docker layer to enable ebook conversion and then in the Calibre-Web admin page (Basic Configuration:External Binaries) set the Path to Calibre E-Book Converter to /usr/bin/ebook-convert on versions 0.6.21 and lower. For 0.6.22 and higher, set the directory, /usr/bin/ only.

This image contains the kepubify ebook conversion tool (MIT License) to convert epub to kepub. In the Calibre-Web admin page (Basic Configuration:External Binaries) set the Path to Kepubify E-Book Converter to /usr/bin/kepubify

## Parameters

Containers are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate <external>:<internal> respectively. For example, -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080 outside the container.

| Parameter | Function |
|-----------|----------|
| -p 8083:8083 | WebUI |
| -e PUID=1000 | for UserID - see below for explanation |
| -e PGID=1000 | for GroupID - see below for explanation |
| -e TZ=Etc/UTC | specify a timezone to use, see this list. |
| -e DOCKER_MODS=linuxserver/mods:universal-calibre | #optional & x86-64 only Adds the ability to perform ebook conversion |
| -e OAUTHLIB_RELAX_TOKEN_SCOPE=1 | Optionally set this to allow Google OAUTH to work |
| -v /config | Where calibre-web stores the internal database and config. |
| -v /books | Where your preexisting calibre database is located. |