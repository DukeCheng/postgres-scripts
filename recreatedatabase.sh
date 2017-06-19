#/bin/sh -e
dbServer="localhost"
newDatabaseName="qin"
WORKSPACE="/var/wwt/source"

echo "UPDATE pg_database SET datallowconn = 'false' WHERE datname = '$newDatabaseName';" | psql -U postgres -h $dbServer postgres
echo "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$newDatabaseName';" | psql -U postgres -h $dbServer postgres
echo "DROP DATABASE IF EXISTS $newDatabaseName" | psql -U postgres -h $dbServer postgres
echo "CREATE DATABASE $newDatabaseName" | psql -U postgres -h $dbServer postgres
echo "UPDATE pg_database SET datallowconn = 'true' WHERE datname = '$newDatabaseName';" | psql -U postgres -h $dbServer postgres

cat ${WORKSPACE}/qin.database/*.sql | psql -U postgres -h $dbServer $newDatabaseName
cat ${WORKSPACE}/qin.database/import/*.sql | psql -U postgres -h $dbServer $newDatabaseName
cat ${WORKSPACE}/qin.database/init-data/*.sql | psql -U postgres -h $dbServer $newDatabaseName
cat ${WORKSPACE}/qin.database/test-data/*.sql | psql -U postgres -h $dbServer $newDatabaseName
