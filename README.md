This Dockerfile contains definitions for creating docker container
images for running the ["Unison Code Manager
(ucm)"](https://www.unisonweb.org/docs/tour). 

## Using these docker images:

See my dockerhub page for a list of docker images I have publised:

* [https://hub.docker.com/repository/registry-1.docker.io/stew/unison/tags]

#### If you want to create a new codebase

### Building

To build from the lastest release (as of this writing: (M1i)[https://github.com/unisonweb/unison/releases/tag/release%2FM1i]):

```
docker build --target RELEASE -t unison:M1i .
```

If you want to build from a different tag 

To build from a different tag (perhaps from the previous release):

```
docker build --target RELEASE --build-arg release=M1h -t unison:M1h .
```

To build from the current master branch from
(github)[https://github.com/unisonweb/unison] from source:

```
docker build --target HEAD -t unison:latest .
```

This will checkout the current master branch from git, install stack,
and build unison from source, then will create a minimal container
without the build environment, just containing the resulting binary.


### Running

