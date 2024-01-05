# DataLayers with Grafana
Visualize the data stored in DataLayers using Grafana.

## How to use

1. Clone the code repository. Please make sure you have installed the `git`, and then running the following commands to start the demo:

  ```bash
  git clone https://github.com/datalayers-io/datalayers-with-grafana.git
  ```

2. Please make sure you have installed the [docker](https://www.docker.com/), and then running the following commands to start the demo:

  ```bash
  cd datalayers-with-grafana

  # Make sure it have execute permissions
  ./init.sh
  

  docker-compose up -d
  ```

3. Running the following commands to see the message from DataLayers:

  ```bash
  docker logs -f datalayers
  ```

4. Connect to DataLayers using the command-line tool:

  ```bash
  docker exec -it datalayers dlsql -u admin -p public
  ```

5. Create a database using the command-line tool:

  ```bash
  docker exec -it datalayers dlsql -u admin -p public
  > create schema demo;
  ```

6. Write data using schemaless:  
Use the following script to write data,
```shell
#!/bin/bash

while true
do
    my_array=(cd bj sh hz sz)
    array_length=${#my_array[@]}
    random_index=$((RANDOM % array_length))
    location=${my_array[$random_index]}

    speed=$((RANDOM % 21 + 100))
    temperature=$((RANDOM % 11 + 10))

    timestamp=$(date +%s%9N) # ns

    line="sensor,location=${location} speed=${speed}i,temperature=${temperature}i ${timestamp}"
    echo $line
    curl -XPOST "http://127.0.0.1:18333/write?precision=ns&p=public&u=admin&db=demo" --data-binary "$line"

done
```

7. Query data through the command line:

  ```bash
  docker exec -it datalayers dlsql -u admin -p public -c "select * from demo.sensor limit 10"
  ```

7. Visualize data using Grafana..

  // todo

## License

[Apache License 2.0](./LICENSE)
