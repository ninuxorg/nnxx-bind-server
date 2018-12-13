#!/bin/bash

BASEFILE=`pwd`
UTENTE=`users`
echo $UTENTE

echo "Nome del dominio?"
read DOMAIN

echo "Gen ZKS"
if [ ! -d $BASEFILE/ZSK ]; then
    mkdir -p $BASEFILE/ZSK;
fi;
cd $BASEFILE/ZSK
dnssec-keygen -a RSASHA256 -b 2048 -r /dev/urandom -n ZONE $DOMAIN
cp K$DOMAIN*.private $DOMAIN.bk
ansible-vault encrypt K$DOMAIN.*.private

echo "GEN KSK"
if [ ! -d $BASEFILE/KSK ]; then
    mkdir -p $BASEFILE/KSK;
fi;
cd $BASEFILE/KSK
dnssec-keygen -f KSK -a RSASHA256 -b 4096 -r /dev/urandom -n ZONE $DOMAIN
cp K$DOMAIN*.private $DOMAIN.bk
ansible-vault encrypt K$DOMAIN.*.private

chown -R $UTENTE: $BASEFILE
