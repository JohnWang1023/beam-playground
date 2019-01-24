FORCE:

clone-beam-cassandra:
	cd .. && git clone git@github.com:srfrnk/beam.git

clone-cassandra-java-driver:
	cd .. && git clone git@github.com:srfrnk/java-driver.git cassandra-java-driver

start-cassandra: FORCE
	docker run -d --rm --name cassandra --network host cassandra

stop-cassandra: FORCE
	docker kill cassandra

create-schema: FORCE
	cqlsh -e "CREATE KEYSPACE IF NOT EXISTS test WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 1}; \
		CREATE TABLE IF NOT EXISTS test.table1 ( data text, an_id uuid, PRIMARY KEY(data) ); \
		CREATE TABLE IF NOT EXISTS test.table2 ( data text, an_id uuid, PRIMARY KEY(data) );"

drop-schema: FORCE
	cqlsh -e "DROP TABLE IF EXISTS test.table1;\
		DROP TABLE IF EXISTS test.table2;\
		DROP KEYSPACE IF EXISTS test;"

truncate-data: FORCE
	cqlsh -e "TRUNCATE test.table1; TRUNCATE test.table2;"

clear:
	@clear

run:
	@gradle --console=plain --refresh-dependencies clean write-cassandra -Drunner=flink-local

tt:
	flink run -d -c org.apache.beam.examples.WriteCassandra /tmp/beam-playground-0.1-all.jar
	kubectl cp ./src mgmt-0:/beam-playground/src
	kubectl exec -it mgmt-0 -- bash -c cd /beam-playground && gradle write-cassandra -Drunner=flink-cluster

.ONESHELL:

build-cassandra-java-driver:
	mvn -f ../cassandra-java-driver clean package

build-beam-cassandra:
	gradle -p ../beam/sdks/java/io/cassandra clean shadowJar
