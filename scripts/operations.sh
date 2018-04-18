#!/bin/bash

set -e
DEFAULT_FILE="bench.cnf"
PAUSE_FILE="pause.txt"
KILL_FILE="kill.txt"
OPERATION=$1

while true; do
  if [[ $OPERATION == "select" ]]; then
    selects=$(mysql --defaults-extra-file=$DEFAULT_FILE -e "SELECT COUNT(*) FROM employees" -NB)
    echo "SELECT COUNT(*) FROM employees: $selects"
  fi

  if [[ $OPERATION == "insert" ]]; then
    id=$(( $(( $RANDOM )) * 15 ))
    inserts=$(mysql --defaults-extra-file=$DEFAULT_FILE -e "INSERT IGNORE INTO employees (emp_no, birth_date, first_name, last_name, hire_date) values ($id, '1990-12-25', 'Bob', 'Smith$id', CURDATE())" || true)
    if [[ $inserts -eq 0 ]]; then
      echo "INSERT IGNORE INTO employees (emp_no, birth_date, first_name, last_name, hire_date) values ($id, '1999-12-25', 'Bob', 'Smith$id', CURDATE())"
    fi
    sleep 1
  
  elif [[ $OPERATION == "update" ]]; then
    updates=$(mysql --defaults-extra-file=$DEFAULT_FILE -e "UPDATE employees SET first_name = 'Alice' where first_name LIKE 'Bob%' ORDER BY RAND() LIMIT 1")
    if [[ $updates -eq 0 ]]; then
      echo "UPDATE employees SET first_name = 'Alice' where first_name LIKE 'Bob%' ORDER BY RAND() LIMIT 1"
    fi
    sleep 2
  
  elif [[ $OPERATION == "delete" ]]; then
    deletes=$(mysql --defaults-extra-file=$DEFAULT_FILE -e "DELETE FROM employees WHERE last_name like 'Smith%' ORDER BY last_name DESC limit 1")
    if [[ $deletes -eq 0 ]]; then
      echo "DELETE FROM employees WHERE last_name like 'Smith%' ORDER BY last_name DESC limit 1"
    fi
    sleep 5
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
