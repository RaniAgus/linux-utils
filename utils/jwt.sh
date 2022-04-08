#!/usr/bin/env bash

# Construct the header
jwt_header=$(echo -n '{"alg":"HS256","typ":"JWT"}' | base64 | sed s/\+/-/g | sed 's/\//_/g' | sed -E s/=+$//)

# Construct the payload
read -p "Enter payload data: " data
echo ""
[ -z "$data" ] && exit

payload=$(echo -n "$data" | base64 | sed s/\+/-/g | sed 's/\//_/g' | sed -E s/=+$//)

# Store the raw user secret (with example of newline at end)
read -s -p "Secret: " secret
echo ""
[ -z "$secret" ] && exit

# Convert secret to hex (not base64)
hexsecret=$(echo -n "$secret" | xxd -p | paste -sd "")

# Calculate hmac signature -- note option to pass in the key as hex bytes
hmac_signature=$(echo -n "${jwt_header}.${payload}" | openssl dgst -sha256 -mac HMAC -macopt hexkey:$hexsecret -binary | base64 | sed s/\+/-/g | sed 's/\//_/g' | sed -E s/=+$//)

# Create the full token
jwt="${jwt_header}.${payload}.${hmac_signature}"

echo $jwt
