#!/bin/bash

read -sp "Enter password: " password
echo

while IFS= read -r line; do
  if [[ "$line" == \#* ]]; then
    # Preserve comments as they are
    echo "$line"
  elif [[ "$line" == *"=ENC["* ]]; then
    name="${line%%=ENC[*}"
    encrypted_value="${line#*=ENC[}"
    encrypted_value="${encrypted_value%]}"
    # Decode the base64 value before decrypting
    decrypted_value=$(echo -n "$encrypted_value" | base64 -d | openssl enc -aes-256-cbc -d -pbkdf2 -nosalt -pass pass:"$password")
    echo "$name=$decrypted_value"
  else
    echo "$line"
  fi
done < .env.secrets.enc > .env.secrets

echo ".env.secrets.enc has been decrypted to .env.secrets"
