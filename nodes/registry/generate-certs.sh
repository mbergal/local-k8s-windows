# Generate private key
echo "Generate private key ..."
openssl genrsa -out registry.key 2048
echo "...done"

echo "Generate CSR ..."
openssl req -new -days 365 -key registry.key -out registry.local.csr -subj "/CN=registry.k8s.local"
echo "...done"

echo "Create certificate ..."
openssl x509 -in registry.local.csr -out registry.local.crt -req -signkey registry.key -days 365
echo "...done"

echo "Copying keys to /vagrant ..."
cp registry.local.crt /vagrant
cp registry.key /vagrant
echo "...done"

mkdir /certs
cp registry.local.crt /certs/
cp registry.key /certs/

 