FROM datasetteproject/datasette:0.54

RUN apt-get update && apt-get -y upgrade && \
  apt-get install --no-install-recommends -y \
  unzip \
  && \
  apt-get clean

WORKDIR /mnt/datasette

# Datasette tools
# for csv import - https://datasette.io/tools/csvs-to-sqlite
# for datasette db maniupluations and tools - https://datasette.io/tools/sqlite-utils
# for geojson api responses - https://pypi.org/project/geojson/
RUN pip install csvs-to-sqlite sqlite-utils geojson

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

# CMD ["datasette", "-p", "80", "-h", "0.0.0.0", "--cors", "/mnt/datasette/databases"]
# fix the dbs not starting in immutable mode, https://github.com/simonw/datasette/pull/1229
CMD ["datasette", "-p", "80", "-h", "0.0.0.0", "--cors", "-i", "databases/darien.db", "-i", "databases/gorongosa.db", "--plugins-dir=databases/plugins", "--inspect-file=databases/inspect-data.json", "--setting", "sql_time_limit_ms", "60000",  "--setting", "max_returned_rows", "2000", "--setting", "hash_urls", "1"]
