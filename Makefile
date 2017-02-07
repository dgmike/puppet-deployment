CLIENTS=$(shell grep '^  puppet' docker-compose.yml  | grep -v puppet_server | tr ':' '  ' | tr "\n" " ")

up:
	docker-compose up -d

down:
	docker-compose down

update:
	for CLIENT in ${CLIENTS}; do \
		echo "$$CLIENT $$ puppet agent -t"; \
		docker-compose exec $$CLIENT puppet agent -t || true; \
	done

cert-list:
	docker-compose exec puppet_server puppet cert list -all

clean:
	docker ps -a | grep 'Exited' | awk '{print $$1}' | xargs -r -n1 docker rm

build: clean up update cert-list

rebuild: down build

create_machinne:
	@echo -n 'Environment: ' ; \
	read MACHINNE_ENVIRONMENT ; \
	echo -n 'Machinne name: ' ; \
	read MACHINNE_NAME ; \
	MACHINNE_PATH=$$MACHINNE_ENVIRONMENT/$$MACHINNE_NAME ; \
	MACHINNE_CONF=$$MACHINNE_PATH/etc/puppet/puppet.conf ; \
	mkdir -p $$MACHINNE_ENVIRONMENT ; \
	cp -rv ./machinne_template $$MACHINNE_PATH ; \
	sed -i "s/###CERTNAME###/$${MACHINNE_NAME}/" $$MACHINNE_CONF ; \
	sed -i "s/###ENVIRONMENT###/$${MACHINNE_ENVIRONMENT}/" $$MACHINNE_CONF ; \
	echo "  puppet_$${MACHINNE_ENVIRONMENT}_$${MACHINNE_NAME}:\n    image: devopsil/puppet\n    command: "tail -f /dev/null"\n    links: ['puppet_server:puppet']\n    volumes: ['./$${MACHINNE_PATH}/etc/puppet:/etc/puppet']\n    depends_on: ['puppet_server']" >> docker-compose.yml