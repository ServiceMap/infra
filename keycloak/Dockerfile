FROM quay.io/keycloak/keycloak:25.0.4

# Install envsubst (gettext)
USER root
RUN microdnf install -y gettext && microdnf clean all

# Copy realm import files and script
COPY ./keycloak/realm-export.json /opt/keycloak/data/import/realm-export.json
COPY ./keycloak/import-realm.sh /opt/keycloak/import-realm.sh
RUN chmod +x /opt/keycloak/import-realm.sh

USER keycloak

ENTRYPOINT ["/opt/keycloak/import-realm.sh"]
