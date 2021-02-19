FROM datasetteproject/datasette:0.54

WORKDIR /mnt/datasette

# Datasette tool for csv import, https://datasette.io/tools/csvs-to-sqlite
RUN pip install csvs-to-sqlite sqlite-utils geojson

# our custom script for converting CSV files to database
COPY labs-import-csv-files-to-sqlite.sh /usr/local/bin/

# Add the csv data files
COPY data/ .
# build the config dir
RUN /usr/local/bin/labs-import-csv-files-to-sqlite.sh
COPY ./plugins/ ./databases/plugins/
COPY settings.json ./databases/

CMD ["datasette", "-h", "0.0.0.0", "--cors", "/mnt/datasette/databases"]
