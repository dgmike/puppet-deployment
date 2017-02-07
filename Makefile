CLIENTS=$(shell grep -e '^  \w' docker-compose.yml | grep -v '^  puppet_server' | tr ':' ' ' | awk '{print $1}' | tr "\n" ' ')
ENVIRONMENTS=$(shell ls -1 puppet_server/opt/puppet/environments | tr "\n" ' ')
SED=$(shell if which gsed > /dev/null; then echo 'gsed'; else echo 'sed'; fi )
XARGS=$(shell if which gxargs > /dev/null; then echo 'gxargs'; else echo 'xargs'; fi )

up:
	docker-compose up -d
	sleep 2

down:
	docker-compose down

update:
	for CLIENT in ${CLIENTS}; do \
		echo "$$CLIENT $$ puppet agent -t"; \
		docker-compose exec $$CLIENT puppet agent -tvd || true; \
	done

cert-list:
	docker-compose exec puppet_server puppet cert list -all

clean:
	docker ps -a | grep 'Exited' | awk '{print $$1}' | ${XARGS} -r -n1 docker rm

build: clean up update cert-list

rebuild: down build

create_machinne:
	@echo "Environment: ( avaiable: ${ENVIRONMENTS})" ; \
	read MACHINNE_ENVIRONMENT ; \
	echo 'Machinne name: ' ; \
	read MACHINNE_NAME ; \
	MACHINNE_PATH=$$MACHINNE_ENVIRONMENT/$$MACHINNE_NAME ; \
	MACHINNE_CONF=$$MACHINNE_PATH/etc/puppet/puppet.conf ; \
	mkdir -p $$MACHINNE_ENVIRONMENT ; \
	cp -rv ./machinne_template $$MACHINNE_PATH ; \
	${SED} -i"" "s/###CERTNAME###/$${MACHINNE_NAME}/" $$MACHINNE_CONF ; \
	${SED} -i"" "s/###ENVIRONMENT###/$${MACHINNE_ENVIRONMENT}/" $$MACHINNE_CONF ; \
	echo "  $${MACHINNE_ENVIRONMENT}_$${MACHINNE_NAME}:\n    image: devopsil/puppet\n    command: "tail -f /dev/null"\n    links: ['puppet_server:puppet']\n    volumes: ['./$${MACHINNE_PATH}/etc/puppet:/etc/puppet']\n    depends_on: ['puppet_server']" >> docker-compose.yml
