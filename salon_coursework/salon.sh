#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~WELCOME TO SUPER SALON~~~~~\n"

SERV_LIST() {

  services_list=$($PSQL "SELECT * FROM services;")

  if [[ $1 ]]
  then
  echo -e "\n$1"
  MAIN_MENU
  fi

  echo "$services_list" | while read SERV_ID BAR SERV
  do
    echo "$SERV_ID) $SERV"
  done
  

}


MAIN_MENU() {
  SERV_LIST
  echo -e "\nSelect a service"
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]$ ]]
  then
    SERV_LIST "Please choose a correct service"
  else
    echo -e "Enter your phone number"
    read CUSTOMER_PHONE
    
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'";)
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nEnter your name"
      read CUSTOMER_NAME

      insert_into_customers=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
      
    fi

    echo -e "\nEnter the service time"
    read SERVICE_TIME

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    insert_into_appointments=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME');")

    if [[ insert_into_appointments == "insert_into_appointments" ]] 
    then

    SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = '$CUSTOMER_ID'")
    echo "I have put you down for a$SERVICE at $SERVICE_TIME,$CUSTOMER_NAME."
    fi
  fi

  
  
}

MAIN_MENU