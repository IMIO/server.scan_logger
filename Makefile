#!/usr/bin/make
#
# plone-path is added when "vhost_path: mount/site" is defined in puppet
plone=$(shell grep plone-path port.cfg|cut -c 14-)
hostname=$(shell hostname)
instance1_port=$(shell grep instance1-http port.cfg|cut -c 18-)
copydata=1
instance=instance-debug

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: setup
setup:  ## Setups environment
	virtualenv .
	./bin/pip install --upgrade pip
	./bin/pip install -r requirements.txt

.PHONY: buildout
buildout:  ## Runs setup and buildout
	rm -f .installed.cfg .mr.developer.cfg
	if ! test -f bin/buildout;then make setup;fi
	bin/buildout -v

.PHONY: cleanall
cleanall:  ## Cleans all installed buildout files
	rm -fr bin include lib local share develop-eggs downloads eggs parts .installed.cfg
	git checkout bin

.PHONY: vcr
vcr:  ## Shows requirements in checkversion-r.html
	bin/versioncheck -rbo checkversion-r.html

.PHONY: vcn
vcn:  ## Shows newer packages in checkversion-n.html
	bin/versioncheck -npbo checkversion-n.html

.PHONY: guard-%
guard-%:
	@ if [ "${${*}}" = "" ]; then echo "You must give a value for variable '$*' : like $*=xxx"; exit 1; fi

.PHONY: oneof-%
oneof-%:
	@ if ! echo "${${*}s}" | tr " " '\n' |grep -Fqx "${${*}}"; then echo "Invalid '$*' parameter ('${${*}}') : must be one of '${${*}s}'"; fi
