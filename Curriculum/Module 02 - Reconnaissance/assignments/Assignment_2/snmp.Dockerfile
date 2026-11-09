FROM docker.io/library/alpine:3.20

# Read-only SNMP with the default `public` community: the classic misconfiguration
# students are told to look for. Everything it discloses is fictional.
RUN apk add --no-cache net-snmp && \
    printf '%s\n' \
      'rocommunity public' \
      'sysLocation Server room B2, Rack 7' \
      'sysContact ops-team@athena-corp.local' \
      'sysName fileserver01.athena-corp.local' \
      'sysDescr Athena Corp file services host' \
      'sysServices 72' \
      > /etc/snmp/snmpd.conf

EXPOSE 161/udp
CMD ["snmpd", "-f", "-Lo", "-C", "-c", "/etc/snmp/snmpd.conf", "udp:161"]
