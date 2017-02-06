CLIENTS=$(shell grep '^  puppet' docker-compose.yml  | grep -v puppet_server | tr ':' '  ' | tr "\n" " ")

up:
	docker-compose up -d

down:
	docker-compose down

update:
	for CLIENT in ${CLIENTS}; do \
		echo "$$CLIENT $$ puppet agent -t"; \
		docker-compose exec $$CLIENT puppet agent -t; \
	done

cert-list:
	docker-compose exec puppet_server puppet cert list -all

clean:
	docker ps -a | grep 'Exited' | awk '{print $$1}' | xargs -r -n1 docker rm

rebuild: down clean up update cert-list