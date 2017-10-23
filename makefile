build:
	@docker-compose -f dev.yml build
build-clean:
	@docker-compose -f dev.yml build --no-cache
run:
	@docker-compose -f dev.yml up -d
stop:
	@docker-compose -f dev.yml stop
clean:	stop
	@docker-compose -f dev.yml rm hybris cpq_db commerce_db
clean-data: clean
	@docker volume rm hybris_commerce_db
	@docker volume rm hybris_cpq_db
clean-images:
	@docker rmi $(docker images -q --filter="dangling=true")
