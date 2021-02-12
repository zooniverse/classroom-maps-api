#!/bin/bash -e

# remove any existing (ephemeral) db as we're going to rebuild it
rm -f "./databases/*.db"

# find all the dirs in data tha have csv, these will be the db names
for db_name in $(find -type f -name *.csv -exec dirname {} \; | uniq | sed 's/.\///');
do
  db_name_path="./databases/$db_name.db"

  # loop over all the csv files (nested?) in the working DIR
  for input_csv_file in $(find $db_name -type f -name *.csv)
  do
    table_name="$(basename $input_csv_file .csv)"
    echo ---
    echo "Importing $input_csv_file to table: $table_name in db: $db_name_path"
    # run the import csv cmd using csvs-to-sqlite
    csvs-to-sqlite --replace-tables $input_csv_file $db_name_path
    echo
  done
done

# inspect the databases to create and inspect file
# used in publishing the database files via datasette
# https://docs.datasette.io/en/latest/settings.html?highlight=immutable#configuration-directory-mode
# https://docs.datasette.io/en/latest/performance.html?highlight=inspect#using-datasette-inspect
datasette inspect --inspect-file databases/inspect-data.json databases/*
