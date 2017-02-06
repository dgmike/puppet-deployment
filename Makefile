CLIENTS=$(shell grep '^  puppet' docker-compose.yml  | grep -v puppet_server | sed 's/://' | tr "\n" " ")

up:
	docker-compose up

agent:
	for CLIENT in ${CLIENTS}; do \
		docker-compose exec $$CLIENT puppet agent -t; \
	done

clean:
	docker ps -a | grep 'Exited' | awk '{print $$1}' | xargs -n1 docker rm
