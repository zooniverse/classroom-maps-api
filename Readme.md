## Installation

Use docker and docker-compose, no other way is supported

## Getting Started

## Building the SQLite db(s)

### Use custom docker image to build the db

``` bash
docker-compose run --rm sqlite-builder
```

The following should run and build a sqlite db for each directory containing csv files in the `/data/` directory

### Or start a bash terminal session if you like

``` bash
docker-compose run --rm --service-ports sqlite-builder bash
# do what you want on the file system
#
# run the builder script manually
labs-import-csv-files-to-sqlite.sh
# ....
# and then start sqlite repl to interact with the database.db file
sqlite3 /mnt/databases/folder/database.db
```

#### Run Datasette with the built sql databases from above

``` bash
docker-compose run --rm --service-ports datasette
```
This will start datasette and serve all the newly created files at http://127.0.0.1:8001

See docker-compose.yaml for more information

##### Run SQL queires directly against the databases

JSON format
- http://127.0.0.1:8001/darien.json?sql=select+*from+subjects+where+subject_id=15684586

HTML format
- http://127.0.0.1:8001/darien?sql=select+*from+subjects+where+subject_id=15684586