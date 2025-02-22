#!/bin/bash
touch emails.lst
grep -E -o -R -i -h "\b\w+@gmail\S*" /etc | tr '\n' ','| sed 's/,$/\n/' >>emails.lst
#sudo chmod o+r /etc/crypttab /etc/lvm/devices /etc/lvm/archive /etc/lvm/backup /etc/lvm/cache /etc/iscsi/iscsid.conf /etc/sssd /etc/pkcs11/rsyslog /etc/security/opasswd /etc/shadow- /etc/sos/cleaner /etc/audit /etc/pwd.lock /etc/gshadow- /etc/gshadow /etc/shadow