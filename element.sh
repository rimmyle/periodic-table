#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
QUERY="select * from elements left join properties using(atomic_number) left join types using(type_id) where "
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
elif [[ ! $1 =~ ^[0-9]+$ && ! $1 =~ ^[A-Z].* ]]
  then
    echo "I could not find that element in the database."
else
  if [[ ! -z $($PSQL "$QUERY symbol='$1';") ]]
  then
    INFO=$($PSQL "$QUERY symbol='$1';")
  elif [[ ! -z $($PSQL "$QUERY name='$1';") ]]
  then  
    INFO=$($PSQL "$QUERY name='$1';") 
  elif [[ ! -z $($PSQL "$QUERY atomic_number=$1;") ]]
  then
    INFO=$($PSQL "$QUERY atomic_number=$1;")
  fi
  echo "$INFO" | while IFS="|" read ID NUMBER SYMBOL NAME MASS MELT BOIL TYPE
  do
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
fi
