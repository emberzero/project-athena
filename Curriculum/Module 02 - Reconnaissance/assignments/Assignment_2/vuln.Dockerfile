FROM docker.io/vulnerables/cve-2014-6271:latest

# No real flag baked in: this repo is public. The portal writes a unique /flag
# into each instance via cloud-init (docker-compose bind-mounts it read-only).
RUN echo "FLAG{replace_me_the_mount_failed}" > /flag
