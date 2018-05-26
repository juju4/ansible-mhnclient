[![Build Status - Master](https://travis-ci.org/juju4/ansible-mhnclient.svg?branch=master)](https://travis-ci.org/juju4/ansible-mhnclient)
[![Build Status - Devel](https://travis-ci.org/juju4/ansible-mhnclient.svg?branch=devel)](https://travis-ci.org/juju4/ansible-mhnclient/branches)
# MHN Clients ansible roles

Ansible role to setup a MHN client.
Mostly a conversion of the shell scripts of https://github.com/threatstream/mhn to ansible config
* https://github.com/threatstream/mhn/
* http://www.505forensics.com/honeypot-data-part-1-mongodb-elasticsearch-mhnclient/

As stated in MHN FAQ, you need proper updates and hardening for those systems. (other roles)

## Requirements & Dependencies

### Ansible
It was tested on the following versions:
 * 1.9.2
 * 2.0
 * 2.1
 * 2.2
 * 2.5

### Operating systems

Tested on Ubuntu 14.04, 16.04, 18.04 and Centos 7

## Example Playbook

Just include this role in your list.
For example

```
- hosts: mhnserver
  roles:
      - juju4.golang
      - juju4.maxmind
      - juju4.mhn
- hosts: mhnclient
  roles:
    - { role: juju4.mhnclient, mhnclient_dionaea: true, mhnclient_glastopf: true, mhnclient_wordpot: true }
```

If you use kippo or cowrie, after first execution, you must change ssh port in your inventory file (manual inventory or vagrant .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory) or Vagrantfile (config.ssh.port) else you will have no connection. Eventually, you can override it from ansible command line (-e).

May need to add a Maxmind dependency for honeymap (configured to look into /var/maxmind)

It is recommended to reboot system after the ansible playbook as updates probably includes kernel one and to ensure everything is fine. Playbook can do it but default variable is noreboot true.


## Example Vagrantfile

Example to use with vagrant on virtualbox joined. need corresponding site.yml (previous section).
Deployment tested on Virtualbox, Amazon and Digital Ocean.

## Variables

Check defaults/main.yml for a full list.

* deploy_key: once server is configured, you can extract this value in /var/mhn/server/config.py or through web interface > deploy. It is mandatory for client configuration.

## Troubleshooting & Known issues

## Known Issues

* BFR support 
https://github.com/mushorg/glastopf/issues/266
works on xenial/php7
issue on trusty/php5

* client registration is currently required in early stage of install which makes CI testing heavy (server install is needed).
Ideally, this role should call other role for each module install (snort, bro, amun...) and just do the adaptation for MHN and registration.

* registration fails sometimes.
returns '502 Bad Gateway'
re-executing role is usually sufficient (use tags to avoid doing all the playbook).

* supervisor doesn't restart correctly (handlers)
just restart service manually.
not sure why it happens as a temporization is already included.

* cowrie telnet support is pending because of hpfeeds to report to mhn server
https://groups.google.com/forum/#!topic/modern-honey-network/jPE38VZmmho

* mtpot has no hpfeeds support


## FAQ

Check
https://github.com/threatstream/mhn/wiki/MHN-Troubleshooting-Guide


## Continuous integration

This role has a travis basic test (for github), more advanced with kitchen and also a Vagrantfile (test/vagrant).
Default kitchen config (.kitchen.yml) is lxd-based, while (.kitchen.vagrant.yml) is vagrant/virtualbox based.

Once you ensured all necessary roles are present, You can test with:
```
$ cd /path/to/roles/juju4.mhn
$ kitchen verify
$ kitchen login
$ KITCHEN_YAML=".kitchen.vagrant.yml" kitchen verify
```
or
```
$ cd /path/to/roles/juju4.mhn/test/vagrant
$ vagrant up
$ vagrant ssh
```

Role has also a packer config which allows to create image for virtualbox, vmware, eventually digitalocean, lxc and others.
When building it, it's advise to do it outside of roles directory as all the directory is upload to the box during building 
and it's currently not possible to exclude packer directory from it (https://github.com/mitchellh/packer/issues/1811)
```
$ cd /path/to/packer-build
$ cp -Rd /path/to/mhn/packer .
## update packer-*.json with your current absolute ansible role path for the main role
## you can add additional role dependencies inside setup-roles.sh
$ cd packer
$ packer build packer-*.json
$ packer build -only=virtualbox packer-*.json
## if you want to enable extra log
$ PACKER_LOG_PATH="packerlog.txt" PACKER_LOG=1 packer build packer-*.json
## for digitalocean build, you need to export TOKEN in environment.
##  update json config on your setup and region.
$ export DO_TOKEN=xxx
$ packer build -only=digitalocean packer-*.json
```

## License

BSD 2-clause

