PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
elif [[ $1 == 1 || $1 == 'H' || $1 == 'Hydrogen' ]]
  then
    echo "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
elif [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$1
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1;");
    if [[ -z $NAME ]]
    then
      echo "I could not find that element in the database."
      exit
    fi
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = '$1';")
    TYPE=$($PSQL "SELECT types.type FROM types JOIN properties ON types.type_id = properties.type_id WHERE properties.atomic_number = $ATOMIC_NUMBER;")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $1;")
    MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $1;")
    BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $1;")
    
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1';")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
      exit
    fi
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER;");
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = '$ATOMIC_NUMBER';")
    TYPE=$($PSQL "SELECT types.type FROM types JOIN properties ON types.type_id = properties.type_id WHERE properties.atomic_number = $ATOMIC_NUMBER;")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
elif [[ $1 =~ ^[a-zA-Z]{2,}$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1';")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
      exit
    fi
    NAME=$1
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = '$ATOMIC_NUMBER';")
    TYPE=$($PSQL "SELECT types.type FROM types JOIN properties ON types.type_id = properties.type_id WHERE properties.atomic_number = $ATOMIC_NUMBER;")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
    
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
else
  echo "I could not find that element in the database."
fi
