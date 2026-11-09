FROM debian:bookworm-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends tor curl ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /var/lib/tor/hs \
 && chown -R debian-tor:debian-tor /var/lib/tor \
 && chmod 700 /var/lib/tor/hs
USER debian-tor
CMD ["tor", "-f", "/etc/tor/torrc"]
