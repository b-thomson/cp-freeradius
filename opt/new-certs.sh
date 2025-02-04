#!/bin/sh
# Deletes old certificates and generates new certificates.
# Valid for 60 days.
# Runs bootstrap twice to ensure it validates the server certificate.

echo "Removing default certificates and generating new ones..."
cd /opt/etc/raddb/certs
make destroycerts > /dev/null 2>&1
./bootstrap > /dev/null 2>&1
./bootstrap > /dev/null 2>&1
echo "Complete."
echo "Displaying new certificates - these are valid for 60 days from now."
echo "Copy & paste these certificates one by one into a text editor and save them as follows."
echo "Press ENTER to start."
read reply
echo ----- COPY BELOW THIS LINE -----
cat /opt/etc/raddb/certs/client.crt
echo
echo "Copy the entire contents above and save the file as client.crt"
echo "Press ENTER to continue..."
read reply
echo ----- COPY BELOW THIS LINE -----
cat /opt/etc/raddb/certs/client.key
echo
echo "Copy the encrypted key contents above and save the file as client.key."
echo
echo "Create a PKCS12 certificate using the above files."
echo "Please refer back to the related article for additional information on this process."
echo
echo "IMPORTANT: The container MUST be restarted before attempting to connect with the new certificate."
echo "It will not work otherwise."
echo
echo "Press any key to exit."
read reply
