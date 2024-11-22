cd $RENEWED_LINEAGE
if [ -f privkey.pem ] && [ -f fullchain.pem ]; then
   cat privkey.pem fullchain.pem > /root/combined.pem
   cd /root/
   openssl pkcs12 -export -in combined.pem -name CISCOAUTOCERT -passout pass:cisco -out /root/ciscoautocert.p12
   mv /root/ciscoautocert.p12 $CAF_APP_PERSISTENT_DIR/
   rm /root/combined.pem
