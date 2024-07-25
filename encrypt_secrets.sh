#!/bin/bash

read -sp "Enter password: " password
echo

while IFS= read -r line; do
  if [[ "$line" == \#* ]]; then
    # Preserve comments as they are
    echo "$line"
  elif [[ "$line" == *"="* ]]; then
    name="${line%%=*}"
    value="${line#*=}"
    # Encrypt the value without a salt for deterministic encryption and base64 encode the result
    encrypted_value=$(echo -n "$value" | openssl enc -aes-256-cbc -a -nosalt -pbkdf2 -pass pass:"$password" | tr -d '\n')
    echo "$name=ENC[$encrypted_value]"
  else
    echo "$line"
  fi
done < .env.secrets > .env.secrets.enc

echo ".env.secrets has been encrypted to .env.secrets.enc"
