# Docker recipe for [ShellCoind](https://github.com/ShellCoin/ShellCoin)

See the global picture how this container interacts with other components to run Shellparty:

[Global Component Overview](http://www.inkpad.io/1GMXYwxl4Q)


## Build

    docker build -t ShellCoind:v1 .


## Instantiate Data Container

    docker run -d --name=ShellCoind-data ShellCoind:v1 bash


## Run Container

    docker run -it --name=ShellCoind --volumes-from=ShellCoind-data ShellCoind:v1 bash


## Run Process

    ShellCoind


## Debug

    docker run -it --rm --volumes-from=ShellCoind-data ShellCoind:v1 bash


## Test

    curl --user user:pass --data-binary '{"jsonrpc": "1.0", "id":"0", "method": "getinfo", "params": [] }' -H 'content-type: text/plain;' http://172.17.0.200:31100/
    curl --user user:pass --data-binary '{"jsonrpc": "1.0", "id":"0", "method": "getblockcount", "params": [] }' -H 'content-type: text/plain;' http://172.17.0.200:31100/

    curl -s https://chain.so/api/v2/get_info/SHELL | json data | json blocks

