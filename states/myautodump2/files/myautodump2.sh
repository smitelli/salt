#!/bin/bash -e

if [[ "$#" != 1 ]]; then
    echo "Usage: $0 /output/dir"
    exit 1
fi

if [[ ! -d "$1" ]]; then
    echo "Output dir doesn't exist: $1"
    exit 1
fi

for db in $(mysql --batch --skip-column-names --execute='SHOW DATABASES'); do
    error_log_file="$1/${db}_error.log"
    sql_file="$1/$db.sql.gz"
    tmp_file="$1/$db.tmp.gz"

    if [[ "$db" == 'performance_schema' ]]; then
        extra_args='--skip-events'
    else
        extra_args=''
    fi

    mysqldump --opt --single-transaction --hex-blob --events --routines \
        --triggers --log-error="$error_log_file" $extra_args "$db" |
        gzip --best > "$tmp_file"

    chown root: "$error_log_file" "$tmp_file"
    chmod 0600 "$error_log_file" "$tmp_file"
    mv --force "$tmp_file" "$sql_file"
done
