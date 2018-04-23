#!/bin/bash
# operation.sh <select|insert|update|delete>

DEFAULT_FILE="/home/ubuntu/scripts/client.cnf"
PAUSE_FILE="/tmp/pause.txt"
KILL_FILE="/tmp/kill.txt"
OPERATION=$1

rm -f $KILL_FILE

while true; do
  if [[ $OPERATION == "select" ]]; then
    selects=$(mysql --defaults-extra-file=$DEFAULT_FILE -e "SELECT COUNT(*) FROM employees" -NB)
    echo "SELECT COUNT(*) FROM employees: $selects"
    sleep 1

  elif [[ $OPERATION == "insert" ]]; then
    id=$(( $(( $RANDOM )) * 15 ))
    mysql --defaults-extra-file=$DEFAULT_FILE -e "INSERT INTO employees (emp_no, birth_date, first_name, last_name, hire_date) values ($id, '1990-12-25', 'Bob', 'Smith$id', CURDATE())" > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
      echo "INSERT INTO employees (emp_no, birth_date, first_name, last_name, hire_date) values ($id, '1990-12-25', 'Bob', 'Smith$id', CURDATE())"
      sleep 0.2
    fi

  elif [[ $OPERATION == "update" ]]; then
    id=$(( $(( $RANDOM )) * 15 ))
    mysql --defaults-extra-file=$DEFAULT_FILE -e "UPDATE employees SET first_name = 'Alice$id' where first_name LIKE 'Bob%' ORDER BY RAND() LIMIT 1" > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
      echo "UPDATE employees SET first_name = 'Alice$id' where first_name LIKE 'Bob%' ORDER BY RAND() LIMIT 1"
      sleep 0.2
    fi

  elif [[ $OPERATION == "delete" ]]; then
    mysql --defaults-extra-file=$DEFAULT_FILE -e "DELETE FROM employees WHERE last_name like 'Smith%' ORDER BY last_name DESC limit 1" > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
      echo "DELETE FROM employees WHERE last_name like 'Smith%' ORDER BY last_name DESC limit 1"
      sleep 15
    fi
  else
    echo "Unknown operation given ($OPERATION)"
    exit 1
  fi
  while [ -f $PAUSE_FILE ]; do
    echo "Paused"
    sleep 5
  done
  if [ -f $KILL_FILE ]; then
    echo "Killed"
    exit 0
  fi
done
