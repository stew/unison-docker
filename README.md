This Dockerfile contains definitions for creating docker container
images for running the ["Unison Code Manager
(ucm)"](https://www.unisonweb.org/docs/tour). 

## Using these docker images:

See my dockerhub page for a list of docker images I have publised:

* [https://hub.docker.com/repository/registry-1.docker.io/stew/unison/tags]

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

In order to use these images, You should create a local directory
which will contain your unison codebase:

```
mkdir codebase
```

and run a docker container with your codebase directory mounted to
`/opt/unison/codebase`. If you are starting from an empty directory,
you will need to first initialize the codebase:

```
docker run -it --rm -v $(pwd)/codebase:/opt/unison/codebase stew/unison:M1i init
```

Subsequently, if you run a container without the `init` argument, you
will be dropped into a `ucm` shell which will be watching for .u files
in your codebase directory:

```
$ mkdir codebase
$ docker run -it --rm -v $(pwd)/codebase:/opt/unison/codebase stew/unison:M1i init
Initializing a new codebase in:
/opt/unison/codebase

$ docker run -it --rm -v $(pwd)/codebase:/opt/unison/codebase stew/unison:M1i 

   _____     _             
  |  |  |___|_|___ ___ ___ 
  |  |  |   | |_ -| . |   |
  |_____|_|_|_|___|___|_|_|
  
  Welcome to Unison!
  
  I'm currently watching for changes to .u files under ~/codebase
  
  Type help to get help. 😎
  
  Enter pull https://github.com/unisonweb/base .base to set up the default base library. 🏗

.> 
```

If you have just initiliazed a new codebase, You will want to pull the
`.base` definitions into your codebase by running `pull https://github.com/unisonweb/base .base`:

```
.> pull https://github.com/unisonweb/base .base
⚙  git clone --quiet --depth 1 'https://github.com/unisonweb/base' /opt/unison/.cache/unisonlanguage/gitfiles/q0rume4r1p1lc5tut0gcbbcvndjgr8ai0qst6ej9bdjr1vcgmtueo0103oi4k
t4tr0m1vok5sbkk91g1qcr2og9pit3rp8ceeq752r8/HEAD
⚙  git -C /opt/unison/.cache/unisonlanguage/gitfiles/q0rume4r1p1lc5tut0gcbbcvndjgr8ai0qst6ej9bdjr1vcgmtueo0103oi4kt4tr0m1vok5sbkk91g1qcr2og9pit3rp8ceeq752r8/HEAD rev-parse
 --git-dir                      
.git                          
                                          
  Here's what's changed in .base after the merge:                                    
                          
  Added definitions:           
                         
    1.   ability Abort (+2 metadata)                                                                                                                                       
    2.   ability Ask a (+2 metadata)                                                                                                                                       
    3.   unique type Author
    4.   builtin type Boolean          
    5.   builtin type Bytes     
    6.   builtin type Char
...
```


So now, outside of the docker container, you can use your local editor to create a file ending in `.u` in your new `codebase` directory and `ucm` will pick up the changes:

Outside the container, run:
```

$ echo "type Foo = Int | String" > codebase/scratch.u
```

And you should see ucm pick up the new definitions:
```
  I found and typechecked these definitions in ~/codebase/scratch.u. If you do an `add` or
  `update`, here's how your codebase would change:
                                    
    ⍟ These new definitions are ok to `add`:
                        
      type Foo                            
                           
```
