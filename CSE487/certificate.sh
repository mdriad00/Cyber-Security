#! /bin/bash

echo 'See tree of files inside the root'
tree
echo ''
echo 'Creating directory:'
echo '###########################################'
mkdir -p ca/{root-ca,sub-ca,server}/{private,certs,newcerts,crl,csr}

echo 'See if the folders are created successfully'
tree ca

echo 'Changing the root of ca and sub ca private folder'
chmod -v 700 ca/{root-ca,sub-ca,server}/private

echo 'Creating file index in both root ca and sub ca'
touch ca/{root-ca,sub-ca}/index

echo 'Seeing ca tree again'
tree ca

echo 'Generating hexadecimal random number of 16 charecter'
openssl rand -hex 16

echo 'writing serial number of root ca'
openssl rand -hex 16 > ca/root-ca/serial

echo 'writing serial number of sub ca'
openssl rand -hex 16 > ca/sub-ca/serial

tree ca

echo 'moving to ca directory'
cd ca

echo $PWD
echo ''
echo ''

echo '<<<Generating private key for root ca, sub ca and server>>>'
echo ''
echo ''

echo 'Public key for rootCA'
openssl genrsa -aes256 -out root-ca/private/ca.key 4096

echo 'Public key for subCA'
openssl genrsa -aes256 -out sub-ca/private/sub-ca.key 4096

echo 'Public key for server'
openssl genrsa -out server/private/server.key 2048

echo 'reviewing the change'
tree
echo ''
echo ''
echo '<<<Generating certificates>>>'
echo ''
echo ''

echo '     Root-CA    '
echo 'Creating root ca.config'
echo 'Insert the code for the root-ca.config'
echo '###########################################'
gedit root-ca/root-ca.conf

echo 'Moving inside root-ca'
cd root-ca

echo $PWD

echo 'Generating root ca certificate'
echo ''
echo '###########################################'
openssl req -config root-ca.conf -key private/ca.key -new -x509 -days 7305 -sha256 -extensions v3_ca -out certs/ca.crt
echo ''
echo 'Ensuring that the certificate has been created properly'
echo ''
openssl x509 -noout -in certs/ca.crt -text

echo ''
echo 'Moving a step back and then to sub-ca'
cd ../sub-ca

echo $PWD
echo '     Sub-CA     '
echo ' Creating sub-ca.config '
echo 'Insert the code into sub-ca.config file'
echo '###########################################'
gedit sub-ca.conf
echo ''
echo 'Seeing the directory once again'
tree
echo ''
echo 'Requesting for sub ca certificate signing request.'
echo ''
openssl req -config sub-ca.conf -new -key private/sub-ca.key -sha256 -out csr/sub-ca.csr
echo ''
echo 'moving to the previous folder'
cd -

echo $PWD
echo 'Signing the request of sub ca by root ca'
echo ''
echo '###########################################'
openssl ca -config root-ca.conf -extensions v3_intermediate_ca -days 3652 -notext -in ../sub-ca/csr/sub-ca.csr -out ../sub-ca/certs/sub-ca.crt
echo ''

tree
echo ''
echo '→.pem file has been generated'
echo ''
cat index

echo '→Root ca signed sub ca'
echo 'Seeing detail'
echo '###########################################'
openssl x509 -noout -text -in ../sub-ca/certs/sub-ca.crt
echo ''
echo ''
echo '<<<Configuring server>>>'
echo ''
cd ../server

echo $PWD
echo 'Generating certificate signing request from server'
echo '###########################################'
openssl req -key private/server.key -new -sha256 -out csr/server.csr
echo ''
echo 'moving to sub ca to sign the server’s certificate'
cd ../sub-ca

echo $PWD
echo 'Sub ca signing certificate request of server'
echo '###########################################'
echo ''

openssl ca -config sub-ca.conf -extensions server_cert -days 365 -notext -in ../server/csr/server.csr -out ../server/certs/server.crt
echo ''
echo 'seeing detail'
cat index
echo 'moving to certs folder to see certificate of server'
cd ../server/certs/

echo $PWD

echo 'See the directory by using command:'
ls

→ We can see that the server.crt file has been generated
echo ''

echo 'Now, concating sub-ca.crt and server.crt and naming the new file chained.crt'
echo '###########################################'
echo ''

cat server.crt ../../sub-ca/certs/sub-ca.crt > chained.crt
echo ''
echo 'Seeing the change'
ls

echo 'moving back to server directory'
cd ..

echo $PWD

echo 'Now write the next code here'
echo 'echo your ip address with web server domain'
echo 'ping your web server'
$SHELL

























