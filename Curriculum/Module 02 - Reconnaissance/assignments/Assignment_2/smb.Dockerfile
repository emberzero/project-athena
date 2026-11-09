FROM docker.io/library/alpine:3.20

# Guest-readable SMB share. No accounts and no passwords: the point of the exercise
# is that an anonymous session already lists the shares and their contents.
RUN apk add --no-cache samba-server samba-client && \
    mkdir -p /share/public /var/lib/samba/private /run/samba && \
    printf '%s\n' \
      'Documents in this share are placeholders for the Athena recon lab.' \
      > /share/public/README.txt && \
    printf '%s\n' \
      'Mon 08:00  weekly full backup -> tape' \
      'Wed 02:00  incremental, fileserver01' \
      'Fri 23:00  offsite sync' \
      > /share/public/backup-schedule.txt && \
    printf '%s\n' \
      'Helpdesk: ext. 4120' \
      'Server room access: badge required, see facility management' \
      > /share/public/it-handbook.txt && \
    chmod -R a+r /share/public

RUN printf '%s\n' \
    '[global]' \
    '   workgroup = ATHENA' \
    '   server string = fileserver01' \
    '   netbios name = FILESERVER01' \
    '   security = user' \
    '   map to guest = Bad User' \
    '   guest account = nobody' \
    '   server min protocol = NT1' \
    '   log level = 1' \
    '' \
    '[public]' \
    '   path = /share/public' \
    '   browseable = yes' \
    '   read only = yes' \
    '   guest ok = yes' \
    > /etc/samba/smb.conf

EXPOSE 139 445
CMD ["smbd", "--foreground", "--no-process-group", "--debug-stdout"]
