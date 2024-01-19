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
  > create schema demo;
  ```

  ![create schema demo](./static/images/create_schema.gif)


6. Write data using schemaless:  
Use the following script to write data,
```
curl -XPOST "http://127.0.0.1:18333/write?precision=ns&p=public&u=admin&db=demo" --data-binary "sensor,location=bj speed=103i,temperature=19i 1705639508013794243" -vvv
```

7. Query data through the command line:

  ```bash
  docker exec -it datalayers dlsql -u admin -p public -c "select * from demo.sensor limit 10"
  ```

8. Visualize data using Grafana:

  Visit: [http://localhost:30300/](http://localhost:30300/)

  Username: admin
  
  Password: public


  Try to add dashboard by `Menu - Dashboards` page.

   ![add dashboard](./static/images/dashboard.jpg)
   
   For example:
   
   ``` sql
   SELECT time_split('13s', _default_time_index_) as ts, avg(speed) FROM demo.sensor where $__timeFilter(ts) and location='cd' group by ts;
   ```
   or use the others [Grafana Variables](https://grafana.com/docs/grafana/latest/dashboards/variables/add-template-variables/#global-variables), like this:

   ``` sql
   SELECT time_split('$__interval', _default_time_index_) as ts, avg(speed) FROM demo.sensor where $__timeFilter(ts) and location='cd' group by ts;
   ```

## License

[Apache License 2.0](./LICENSE)
