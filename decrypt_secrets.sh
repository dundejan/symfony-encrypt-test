#!/bin/bash

read -sp "Enter password: " password
echo

while IFS= read -r line; do
  if [[ "$line" == *"=ENC["* ]]; then
    name="${line%%=ENC[*}"
    encrypted_value="${line#*=ENC[}"
    encrypted_value="${encrypted_value%]}"
    # Remove the -salt option to match the encryption process
    decrypted_value=$(echo -n "$encrypted_value" | openssl enc -aes-256-cbc -a -d -pbkdf2 -nosalt -pass pass:"$password")
    echo "$name=$decrypted_value"
  else
    echo "$line"
  fi
done < .env.secrets.enc > .env.secrets

echo ".env.secrets.enc has been decrypted to .env.secrets"
