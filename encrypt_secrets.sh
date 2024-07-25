#!/bin/bash

read -sp "Enter password: " password
echo

while IFS= read -r line; do
  if [[ "$line" == *"="* ]]; then
    name="${line%%=*}"
    value="${line#*=}"
    # Remove the -salt option to ensure deterministic encryption
    encrypted_value=$(echo -n "$value" | openssl enc -aes-256-cbc -a -pbkdf2 -nosalt -pass pass:"$password")
    echo "$name=ENC[$encrypted_value]"
  else
    echo "$line"
  fi
done < .env.secrets > .env.secrets.enc

echo ".env.secrets has been encrypted to .env.secrets.enc"
