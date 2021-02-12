## Installation

Use docker and docker-compose, no other way is supported

## Getting Started

## Use Datasette to launch the API

TODO!

## Building the SQLite db

### Use Datasett to build the db

``` bash
docker-compose run --rm sqlite
```

### Or start a bash terminal session if you like

``` bash
docker-compose run --rm sqlite /bin/bash
# do what you want on the file system
# ....
# and then start sqlite repl to interact with the database.db file
sqlite3 database.db
```

#### Import CSV file data to a sql lite database

https://sqlite-utils.datasette.io/en/stable/cli.html#inserting-csv-or-tsv-data


``` bash
# run this script to ingest all the csv files into the supplied database name


# Alternatively run the cmds manually
#
# run the sqlite-utils docker image to build the sqlite db
docker-compose run --rm sqlite-utils

# import the subjects csv file and create the schema :boom:
sqlite-utils insert darien-labs.db subjects ./darien-map-database-20190131/subjects.csv --csv
# display the resulting table schema :tada:
.schema subjects

# repeat for the cameras
sqlite-utils insert darien-labs.db cameras ./darien-map-database-20190131/cameras.csv --csv
# display the resulting table schema
.schema cameras

#
# repeat for the aggregations
sqlite-utils insert darien-labs.db aggregations ./darien-map-database-20190131/aggregations.csv --csv
# display the resulting table schema :tada:
.schema aggregations

#
# repeat for the vegetation_map
sqlite-utils insert darien-labs.db vegetation_map ./darien-map-database-20190131/vegetation_map.csv --csv
# display the resulting table schema
.schema vegetation_map

#
# repeat for the darien_national_park
sqlite-utils insert darien-labs.db darien_national_park ./darien-map-database-20190131/darien_national_park.csv --csv
# display the resulting table schema
.schema darien_national_park

#
# repeat for the soberania_national_park
sqlite-utils insert darien-labs.db soberania_national_park ./darien-map-database-20190131/soberania_national_park.csv --csv
# display the resulting table schema
.schema soberania_national_park
```
