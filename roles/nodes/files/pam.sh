#!/bin/bash

cat <<EOF | augtool
set /files/etc/pam.d/sshd/#comment[.='pam_selinux.so close should be the first session rule'] 'pam_openshift.so close should be the first session rule'
ins 01 before /files/etc/pam.d/sshd/*[argument='close']
set /files/etc/pam.d/sshd/01/type session
set /files/etc/pam.d/sshd/01/control required
set /files/etc/pam.d/sshd/01/module pam_openshift.so
set /files/etc/pam.d/sshd/01/argument close
set /files/etc/pam.d/sshd/01/#comment 'Managed by openshift_origin'

set /files/etc/pam.d/sshd/#comment[.='pam_selinux.so open should only be followed by sessions to be executed in the user context'] 'pam_openshift.so open should only be followed by sessions to be executed in the user context'
ins 02 before /files/etc/pam.d/sshd/*[argument='open']
set /files/etc/pam.d/sshd/02/type session
set /files/etc/pam.d/sshd/02/control required
set /files/etc/pam.d/sshd/02/module pam_openshift.so
set /files/etc/pam.d/sshd/02/argument[1] open
set /files/etc/pam.d/sshd/02/argument[2] env_params
set /files/etc/pam.d/sshd/02/#comment 'Managed by openshift_origin'

rm /files/etc/pam.d/sshd/*[module='pam_selinux.so']

set /files/etc/pam.d/sshd/03/type session
set /files/etc/pam.d/sshd/03/control required
set /files/etc/pam.d/sshd/03/module pam_namespace.so
set /files/etc/pam.d/sshd/03/argument[1] no_unmount_on_close
set /files/etc/pam.d/sshd/03/#comment 'Managed by openshift_origin'

set /files/etc/pam.d/sshd/04/type session
set /files/etc/pam.d/sshd/04/control optional
set /files/etc/pam.d/sshd/04/module pam_cgroup.so
set /files/etc/pam.d/sshd/04/#comment 'Managed by openshift_origin'

set /files/etc/pam.d/runuser/01/type session
set /files/etc/pam.d/runuser/01/control required
set /files/etc/pam.d/runuser/01/module pam_namespace.so
set /files/etc/pam.d/runuser/01/argument[1] no_unmount_on_close
set /files/etc/pam.d/runuser/01/#comment 'Managed by openshift_origin'

set /files/etc/pam.d/runuser-l/01/type session
set /files/etc/pam.d/runuser-l/01/control required
set /files/etc/pam.d/runuser-l/01/module pam_namespace.so
set /files/etc/pam.d/runuser-l/01/argument[1] no_unmount_on_close
set /files/etc/pam.d/runuser-l/01/#comment 'Managed by openshift_origin'

set /files/etc/pam.d/su/01/type session
set /files/etc/pam.d/su/01/control required
set /files/etc/pam.d/su/01/module pam_namespace.so
set /files/etc/pam.d/su/01/argument[1] no_unmount_on_close
set /files/etc/pam.d/su/01/#comment 'Managed by openshift_origin'

set /files/etc/pam.d/system-auth-ac/01/type session
set /files/etc/pam.d/system-auth-ac/01/control required
set /files/etc/pam.d/system-auth-ac/01/module pam_namespace.so
set /files/etc/pam.d/system-auth-ac/01/argument[1] no_unmount_on_close
set /files/etc/pam.d/system-auth-ac/01/#comment 'Managed by openshift_origin'
save
EOF



cat <<EOF > /etc/security/namespace.d/sandbox.conf
# /sandbox        \$HOME/.sandbox/      user:iscript=/usr/sbin/oo-namespace-init       root,adm,apache
EOF

cat <<EOF > /etc/security/namespace.d/tmp.conf
/tmp        \$HOME/.tmp/      user:iscript=/usr/sbin/oo-namespace-init root,adm,apache
EOF

cat <<EOF > /etc/security/namespace.d/vartmp.conf
/var/tmp    \$HOME/.tmp/   user:iscript=/usr/sbin/oo-namespace-init root,adm,apache
EOF


cat <<EOF | augtool
set /files/etc/login.defs/UID_MIN 500
set /files/etc/login.defs/GID_MIN 500
save
EOF
