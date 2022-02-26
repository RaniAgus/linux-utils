#!/bin/bash -x

set -e

NAME=${1:?}
SSH_USERNAME=${2:?}
SSH_SERVERNAME=${3:?}
SSH_IPADDR=${4:?}

mkdir ${NAME}

# Generate ppk file
puttygen -t rsa -b 2048 -C "${SSH_USERNAME}@${SSH_SERVERNAME}" -o ${NAME}/${NAME}.ppk

# Generate pem from ppk
puttygen ${NAME}/${NAME}.ppk -O private-openssh -o ${NAME}/${NAME}.pem

# Store public key in ssh server
puttygen -L ${NAME}/${NAME}.ppk | xargs -i ssh ${SSH_USERNAME}@${SSH_IPADDR} -f 'mkdir -p -m 700 ~/.ssh && echo {} >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'

# Test connection
ssh ${SSH_USERNAME}@${SSH_IPADDR} -i ${NAME}/${NAME}.pem
