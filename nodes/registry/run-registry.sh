docker run -d -p 443:5000 \
    --restart=always \
    --name registry \
    -v /certs:/certs \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.local.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
    registry:2