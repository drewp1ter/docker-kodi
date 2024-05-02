Build from sources and dockerized [Kodi](https://kodi.tv/) with audio and video.

## Host Prerequisites

The host system will need the following:

1. **Linux** and [**Docker**](https://www.docker.com)

   This image should work on any Linux distribution with a functional Docker installation.
   
1. **A connected display and speaker(s)**

   If you're looking for a headless Kodi installation, look elsewhere!

1. **[X](https://www.x.org/) or [Wayland](https://wayland.freedesktop.org/)**

   Ensure that the packages for an X or Wayland server are present on the Docker host. Please consult your distribution's 
   documentation if you're not sure what to install. A display server does *not* need to be running ahead of time.

1. **[x11docker](https://github.com/mviereck/x11docker/)**

   `x11docker` allows Docker-based applications to utilize X and/or Wayland on the host. Please follow the `x11docker` 
   [installation instructions](https://github.com/mviereck/x11docker#installation) and ensure that you have a 
   [working setup](https://github.com/mviereck/x11docker#examples) on the Docker host.
       
## Usage

### Starting Kodi

Use `x11docker` to start the `erichough/kodi` Docker image. Detailing the myriad of `x11docker` options is beyond the 
scope of this document; please consult the [`x11docker` documentation](https://github.com/mviereck/x11docker/) to find 
the set of options that work for your setup.

Below is an example command (split into multiple lines for clarity) that starts Kodi with a fresh X.Org X server with
PulseAudio sound, hardware video acceleration, a persistent Kodi home directory, and a shared read-only Docker mount for
media files:

    $ sudo x11docker --xorg                                 \
                     --pulseaudio                           \
                     --gpu                                  \
                     -- -v /host/path/to/media:/media:ro    \
                        -v kodi:/home/ubuntu/.kodi --       \
                     docker-kodi
           
Note that the optional argument passed between a pair of `--` defines additional arguments to be passed to `docker run`.

### Stopping Kodi

You can shut down Kodi just as you normally would; i.e. by using the power menu from the Kodi home screen. 
Behind the scenes, the Docker container and `x11docker` processes will terminate cleanly.

You can also [terminate the container from the command line](doc/advanced.md#command-line-shutdown).
