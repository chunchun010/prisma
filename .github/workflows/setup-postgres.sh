#!/bin/bash

if [ "$RUNNER_OS" = "Windows" ]; then
    echo "$PGBIN" >> $GITHUB_PATH
    echo "PQ_LIB_DIR=$PGROOT\lib" >> $GITHUB_ENV
    echo "TEST_POSTGRES_URI=postgres://postgres:root@localhost:5432/tests" >> $GITHUB_ENV
fi

if [ "$RUNNER_OS" = "macOS" ]; then
    export PGDATA="$RUNNER_TEMP/pgdata"
    echo "PGUSER=$USER" >> $GITHUB_ENV

    pg_ctl init
    pg_ctl start
    createuser --createdb prisma
    createdb -O prisma tests
    psql -c "ALTER USER prisma PASSWORD 'prisma';" tests

    echo "TEST_POSTGRES_URI=postgres://prisma:prisma@localhost:5432/tests" >> $GITHUB_ENV
fi