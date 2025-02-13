#!/bin/bash

OUTPUT_CONF=$HOME/direwolf.tmp.conf
DIRECMD="direwolf -p -t 0 -c $OUTPUT_CONF"
search_string="[USB Audio Device]"
card_number=0

# Run the list command to identify the correct card
while IFS= read -r line; do
  # Check if the line contains the search_string
  if [[ "$line" == *"$search_string"* ]]; then
    # Extract the card number (the number right after 'card')
    card_number=$(echo "$line" | awk '{print $2}' | cut -d: -f1)
    break
  fi
done < <(arecord -l)  

if [ "$1" = 'winlink' ]; then
	TYPE="Winlink"
	echo "ADEVICE plughw:$card_number,0" > $OUTPUT_CONF
	cat $HOME/direwolf.footer >> $OUTPUT_CONF
else
	TYPE="TNC"
	cp $HOME/direwolf.tnc.header $OUTPUT_CONF
	echo "ADEVICE plughw:${card_number},0" >> $OUTPUT_CONF
	cat $HOME/direwolf.footer >> $OUTPUT_CONF
fi

echo "Starting Direwolf for $TYPE operation"
echo "$DIRECMD"
$DIRECMD
