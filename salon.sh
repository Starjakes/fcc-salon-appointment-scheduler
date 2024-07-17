#!/bin/bash

# Function to display the list of services
display_services() {
  echo -e "\n1) cut\n2) color\n3) perm"
}

# Function to get customer details
get_customer() {
  CUSTOMER_PHONE=$1
  CUSTOMER_NAME=$(psql --username=freecodecamp --dbname=salon -t --no-align -c "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
  
  if [[ -z $CUSTOMER_NAME ]]; then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    psql --username=freecodecamp --dbname=salon -c "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');"
  fi
}

# Main script execution
echo -e "\nWelcome to the salon! How can we help you today?"

# Display services and get user input
display_services
read SERVICE_ID_SELECTED

# Validate service selection
while [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]$ ]]; do
  echo -e "\nInvalid selection. Please choose a service."
  display_services
  read SERVICE_ID_SELECTED
done

# Get customer phone number and details
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
get_customer $CUSTOMER_PHONE

# Get appointment time
echo -e "\nWhat time would you like your service?"
read SERVICE_TIME

# Insert the appointment into the appointments table
CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon -t --no-align -c "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
SERVICE_NAME=$(psql --username=freecodecamp --dbname=salon -t --no-align -c "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")

psql --username=freecodecamp --dbname=salon -c "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');"

# Confirm the appointment
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
