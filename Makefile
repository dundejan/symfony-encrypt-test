ENCRYPTED_FILE = .env.secrets.enc
DECRYPTED_FILE = .env.secrets

encrypt-secret-variables:
	@bash encrypt_secrets.sh

decrypt-secret-variables:
	@bash decrypt_secrets.sh

.PHONY: encrypt-secret-variables decrypt-secret-variables
