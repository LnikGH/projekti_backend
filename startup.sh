#! /bin/bash
METADATA_VALUE1=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/kek -H "Metadata-Flavor: Google")
METADATA_VALUE2=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/kak -H "Metadata-Flavor: Google")
METADATA_VALUE3=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/kok -H "Metadata-Flavor: Google")
sudo apt-get update
sudo apt-get -y install postgresql
export PGPASSWORD=$METADATA_VALUE1
psql -h $METADATA_VALUE3 -U $METADATA_VALUE2 -d 'group3db' -c "CREATE TABLE maukka ( personID int, lastname varchar(255), firstname varchar(255), address varchar(255), city varchar(255));"