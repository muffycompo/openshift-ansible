openshift-ansible
=================

Ansible script to deploy OpenShift Origin w/ FreeIPA Integration (DNS and Kerberos). Forked from https://github.com/ansible/ansible-examples/tree/master/openshift

Please see above for the layout diagram, I have merely modified to work with the latest nightly builds and to integrate with FreeIPA.

Tested on CentOS 6.5 

Steps:
- Modify variables in group_vars/all
- Generate random string for r2o-openshift/roles/mongodb/files/secret
	openssl rand -base64 741
- roles/broker/vars/main.yml
	# Use this to generate salt 
	# openssl rand -base64 64
	auth_salt: "lk32rsjdpdgSK+BacvsrfdQi6pDW7HMen3uJFykUwOQBoCsvqNZ68po9+N8w=="
	session_secret: "skdlfj3klSDFkjsdO+Yao9VoUx69ikwfiRdph9oXplWDaQ10yWV8y0iFiCf8lTzj40M6b9NIV+wtIuLv/Y/ODjmtJ399g=="
- Regenerate SSL Certs roles/broker/files
	openssl genrsa -out server_priv.pem 2048
	openssl rsa -in server_priv.pem -pubout > server_pub.pem
- On Ansible Host run
	ssh-keygen

- RUN IT!
	ansible-playbook -i hosts site.yml


Post Install (Because I suck at Ansible):
- Fix Networking (Because I use eth0 for private, and eth1 as public)
	Modify on nodes /etc/openshift/node.conf (set the external ip address, external hostname)
	Ensure on nodes /etc/sysconfig/network-scripts/ifcfg-eth1
- Configure FreeIPA Dynamic Updates (Use Web-UI)
	Create domain name
	DNS -> Settings and append
		grant DNS\047oo-broker01.oo.example.net@EXAMPLE.NET wildcard * ANY; grant DNS\047oo-broker02.oo.example.net@EXAMPLE.NET wildcard * ANY;
	Tick Allow Dynamic Updates
	
- Add Districts, Configure SSL Certs
