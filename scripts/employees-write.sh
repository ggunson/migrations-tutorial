#!/bin/bash

set -e
HOST=ggunson-test2.c2kw1eiqbprj.us-east-1.rds.amazonaws.com

ID=0
INCR=0
MAXID=499999
SELECTMAX="SELECT id FROM employees ORDER BY id DESC LIMIT 1"
SELECT="SELECT * FROM employees WHERE emp_no = "
INSERT="INSERT INTO employees (birth_date, first_name, last_name, hire_date) values ('1999-12-25', 'joe$INCR', 'fresh$INCR', CURDATE())"
DELETE="DELETE FROM employees WHERE id = $MAXID * RAND()"
UPDATE="UPDATE employees SET first_name = 'alice' where first_name LIKE 'joe%' ORDER BY RAND() LIMIT 1"

while true; do 
  id=$(( $(( $RANDOM )) * 15 ))
  echo "$SELECT $id"
  result=$(mysql --defaults-extra-file="/Users/ggunson/bin/bench.cnf" -h$HOST employees -e "$SELECT $id")
  if [[ -n $result ]] && [[ $(( $INCR % 3 )) -eq 0 ]]; then
    echo $result;
    echo
  elif [[ $(( $INCR % 3 )) -eq 0 ]]; then
    inserts=$(mysql --defaults-extra-file="/Users/ggunson/bin/bench.cnf" -h$HOST employees -e "INSERT INTO employees (emp_no, birth_date, first_name, last_name, hire_date) values ($id, '1999-12-25', 'joe', 'fresh$id', CURDATE())")
    if [[ $inserts -eq 0 ]]; then
      echo
      echo "INSERT INTO employees (emp_no, birth_date, first_name, last_name, hire_date) values ($id, '1999-12-25', 'joe', 'fresh$id', CURDATE())\n"
      echo 
    fi
  fi
  
  INCR=$((INCR + 1))
  if [[ $(($INCR % 10)) -eq 0 ]]; then
    updates=$(mysql --defaults-extra-file="/Users/ggunson/bin/bench.cnf" -h$HOST employees -e "$UPDATE")
    if [[ $updates -eq 0 ]]; then
      echo "$UPDATE"
      echo
    fi
  fi

  if [[ $(($INCR % 13)) -eq 0 ]]; then
    deletes=$(mysql --defaults-extra-file="/Users/ggunson/bin/bench.cnf" -h$HOST employees -e "DELETE FROM employees WHERE last_name like 'fresh%' ORDER BY last_name DESC limit 1")
    if [[ $deletes -eq 0 ]]; then
      echo "DELETE FROM employees WHERE last_name like 'fresh%' ORDER BY last_name DESC limit 1"
      echo
    fi
  fi
done
