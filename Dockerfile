FROM datasetteproject/datasette:latest

RUN apt-get update 
# RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y build-essential unzip
RUN apt-get clean

WORKDIR /mnt/datasette

# Datasette tools
# for csv import - https://datasette.io/tools/csvs-to-sqlite
# for datasette db maniupluations and tools - https://datasette.io/tools/sqlite-utils
# for geojson api responses - https://pypi.org/project/geojson/
RUN pip install csvs-to-sqlite sqlite-utils geojson plpygis

# pandas 2.0 breaks csvs-to-sqlite.
# https://github.com/simonw/csvs-to-sqlite/pull/92
RUN pip install --force-reinstall "pandas~=1.0"

# Add the csv data files
COPY data/ .

# decompress the zip data folders
RUN unzip -o \*.zip

# our custom script for converting CSV files to database
COPY labs-import-csv-files-to-sqlite.sh /usr/local/bin/

# build the config dir
RUN /usr/local/bin/labs-import-csv-files-to-sqlite.sh
COPY ./plugins/ ./databases/plugins/
COPY settings.json ./databases/

RUN datasette install datasette-hashed-urls

# CMD ["datasette", "-p", "80", "-h", "0.0.0.0", "--cors", "/mnt/datasette/databases"]
# fix the dbs not starting in immutable mode, https://github.com/simonw/datasette/pull/1229
CMD ["datasette", "-p", "80", "-h", "0.0.0.0", "--cors", "-i", "databases/darien.db", "-i", "databases/gorongosa.db", "-i", "databases/kenya.db", "--plugins-dir=databases/plugins", "--inspect-file=databases/inspect-data.json", "--setting", "sql_time_limit_ms", "60000",  "--setting", "max_returned_rows", "50000"]
