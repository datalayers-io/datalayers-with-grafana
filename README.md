# DataLayers with Grafana
Visualize the data stored in DataLayers using Grafana.

## How to use

1. Clone the code repository. Please make sure you have installed the `git`, and then running the following commands to start the demo:

  ```bash
  git clone https://github.com/datalayers-io/datalayers-with-grafana.git
  ```
  Please run the following script first.
  ```bash
  cd datalayers-with-grafana
  
  ./init.sh  # Make sure it have execute permissions
  ```

2. Please make sure you have installed the [docker](https://www.docker.com/), and then running the following commands to start the demo:

  ```bash
  docker-compose up -d
  ```

  ![docker-compose up -d](./static/images/docker_compose.gif)


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
  dlsql> create schema demo;
  ```

  ![create schema demo](./static/images/create_schema.gif)

  You can use `exit` command to exit the dlsql session.

6. Write data using schemaless:  
Use the following script to write data,
```
while true
do
    speed=$((RANDOM % 21 + 100))
    temperature=$((RANDOM % 11 + 10))
    timestamp=$(date +%s%9N) # ns
    line="sensor,location=cd speed=${speed}i,temperature=${temperature}i ${timestamp}"
    echo $line
    sleep 1
    curl -XPOST "http://127.0.0.1:18361/write?precision=ns&p=public&u=admin&db=demo" --data-binary "$line"
done
```

7. Query data through the command line:

  ```bash
  docker exec -it datalayers dlsql -u admin -p public -c "select * from demo.sensor limit 10"
  ```

8. Visualize data using Grafana:

  Visit: [http://localhost:30300/](http://localhost:30300/)

  Username: admin
  
  Password: admin


  Try to add dashboard by `Menu - Dashboards` page.

   ![add dashboard](./static/images/dashboard.jpg)
   
   For example:
   
   ``` sql
   SELECT time_split('5s', _default_time_index_) as ts, avg(speed) FROM demo.sensor where $__timeFilter(ts) and location='cd' group by ts;
   ```
   or use the others [Grafana Variables](https://grafana.com/docs/grafana/latest/dashboards/variables/add-template-variables/#global-variables), like this:

   ``` sql
   SELECT time_split('$__interval', _default_time_index_) as ts, avg(speed) FROM demo.sensor where $__timeFilter(ts) and location='cd' group by ts;
   ```

## License

[Apache License 2.0](./LICENSE)
