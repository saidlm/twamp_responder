#!/bin/bash

# TWAMP-Responder firewall script v 1.1 
# (c) 2022 Martin Saidl@tone.cz

# Environment vars
# CHAIN - iptables chain
# IP - TWAMPD IP address
# DATA_DIR - configuration directory


ALLOW="hosts.allow"
DENY="hosts.deny"

# Cleanup 
cleanup() {
  echo "Cleaning up ..."
  iptables -D FORWARD -j $CHAIN
  iptables -F $CHAIN
  iptables -X $CHAIN
  echo "done."
  exit 0
}

# Signal handling
trap cleanup INT TERM STOP KILL

# Main
echo "Configuring firewall for TWAMP responder ..."
echo "TAMP Chain: $CHAIN"
echo "TWAMP IP: $IP"

echo "Existing $CHAIN rules:"
iptables -S $CHAIN
if [ 0 -ne $? ]; then
  iptables -N $CHAIN
fi

echo "Flushing $CHAIN chain."
iptables -D FORWARD -j $CHAIN
iptables -F $CHAIN

# Output rules 
iptables -A $CHAIN -s $IP -m state --state RELATED,ESTABLISHED -j ACCEPT 

# Input rules (hosts.deny)
if [ -f "$DATA_DIR/$DENY" ]; then
  echo "Processing $DENY ..."
  while read SRCIP; do
    if [[ $SRCIP =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}(/[0-9]{1,2}){0,1}+$ ]]; then
      echo "  Adding $SRCIP to $CHAIN chain"
      iptables -A $CHAIN -d $IP -s $SRCIP -j DROP
    fi
  done < $DATA_DIR/$DENY
  echo "done."
fi

# Input rules (hosts.allow)
if [ -f "$DATA_DIR/$ALLOW" ]; then
  echo "Processing $ALLOW ..."
  while read SRCIP; do
    if [[ $SRCIP =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}(/[0-9]{1,2}){0,1}+$ ]]; then
      echo "  Adding $SRCIP to $CHAIN chain"
      iptables -A $CHAIN -d $IP -s $SRCIP -j ACCEPT
    fi
  done < $DATA_DIR/$ALLOW
  echo "done."
fi

# Final drop
echo "Adding final drop into $CHAIN chain"
iptables -A $CHAIN -s $IP -j DROP
iptables -A $CHAIN -d $IP -j DROP

echo "Current $CHAIN chain:"
iptables -S $CHAIN

iptables -I FORWARD -j $CHAIN

echo "done."

while true; do
  sleep 1 &
  wait $!
done

exit 0
