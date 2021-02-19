FROM datasetteproject/datasette:0.54

WORKDIR /mnt

# Datasette tool for csv import, https://datasette.io/tools/csvs-to-sqlite
RUN pip install csvs-to-sqlite sqlite-utils geojson

# our custom script for converting CSV files to database
COPY labs-import-csv-files-to-sqlite.sh /usr/local/bin/

CMD ["/bin/bash"]
# once we've got the tooling, use this
# CMD ["labs-import-csv-files-to-sqlite.sh"]
