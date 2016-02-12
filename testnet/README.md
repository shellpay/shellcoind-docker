# Docker recipe for [ShellCoind](https://github.com/ShellCoin/ShellCoin)

See the global picture how this container interacts with other components to run Shellparty:

[Global Component Overview](http://www.inkpad.io/1GMXYwxl4Q)

If you intend to build an entire testnet stack of Shellparty using Docker, you will definitely start here. Therefore, this README provides some complementary information about handling Docker itself, smoothing out the rough edges of being new to both technologies.

## Build

Pre-requisite: [Docker installation](https://docs.docker.com/).

Now build this docker project according to the recipe found at ``your/path/to/ShellCoind-docker/testnet/Dockerfile``.

```
cd /your/path/to/ShellCoind-docker/testnet
docker build -t ShellCoind:testnet .
```
Wait for ``Successfully built [your image_id presented here]`` (may take 10+ mins. on first run).

Then issue command ```docker images``` to find a result similar to this:

| REPOSITORY |   TAG   |  IMAGE ID    |    CREATED     | VIRTUAL SIZE |
| ---------- | ------- | ------------ | -------------- | ------------ |
| ShellCoind  | testnet | ba3f4163b790 | 30 minutes ago | 1.791 GB |
| ubuntu     | 14.04   | 826544226fdc | 4 days ago     | 194.2 MB |

What you have now is a Docker _image_ identified by _ba3f4163b790_ (think your id here), stored in a _repository_ called _ShellCoind_ and _tagged_ as _testnet_.

## Instantiate Data Container

In order to separate ShellCoind _execution_ from its _data_, we will now create a separate Docker data volume _container_ for use by the ShellCoin software. This makes it possible for future builds of the ShellCoin software to reuse the data, instead of having to wait for the long-running process of re-reading the data off the ShellCoin peers.

``docker run -d --name=ShellCoind-testnet-data ShellCoind:testnet bash``


## Run Container

First time: Create, Launch & Attach to a docker _container_ named _ShellCoind-testnet_, using the image _ShellCoind:testnet_ and the data container volume _ShellCoind-testnet-data_:

``docker run -it --name=ShellCoind-testnet --volumes-from=ShellCoind-testnet-data ShellCoind:testnet bash``

OR

Consecutive times: Launch & Attach to the docker container:

``
docker start ShellCoind-testnet
docker attach ShellCoind-testnet
``

#### Detaching from container

In order to keep the container running while leaving the container shell:

``ctrl-p ctrl-q``

and back again:

``docker attach ShellCoind-testnet``

#### Stopping the container

From the host shell:

``docker stop ShellCoind-testnet``

From the container shell:

``exit``

## Run Process

Run the ShellCoind daemon from within the container shell:

``ShellCoind &``

Then check the daemon status by means of its Command-Line Interface:

``ShellCoin-cli getinfo``

## Test

To test how other docker containers access _ShellCoind-testnet_, we first need to get the IP address of it:

``docker inspect ShellCoind-testnet | grep IPAddress``

Then edit the _curl_ requests below and run them from the host shell ( or from ``boot2docker ssh`` if running on MacOsX, see [how-to-use-docker-on-os-x-the-missing-guide](http://viget.com/extend/how-to-use-docker-on-os-x-the-missing-guide))


	curl --user user:pass --data-binary '{"jsonrpc": "1.0", "id":"0", "method": "getinfo", "params": [] }' -H 'content-type: text/plain;' http://[insert IP here]:44555/

	curl --user user:pass --data-binary '{"jsonrpc": "1.0", "id":"0", "method": "getblockcount", "params": [] }' -H 'content-type: text/plain;' http://[Insert IP here]:44555/


Finally, you might want to compare the number of blocks downloaded by your newly running ShellCoin docker container with the state of the block chain out there:

	curl -s https://chain.so/api/v2/get_info/SHELLTEST

