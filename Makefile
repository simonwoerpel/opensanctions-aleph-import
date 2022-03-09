export FTM_STORE_URI=postgresql:///ftm

all: install opensanctions rus_recent

install:
	pip install followthemoney-store alephclient pyicu psycopg2

opensanctions:
	# python3 update_collections.py
	curl -s https://data.opensanctions.org/datasets/latest/index.json | jq -r '.datasets[] | [.name, .title, .resources[0].url] | @csv' | csvcut | grep -v ^all | while IFS=, read -r name title url; do \
		echo "processing $$title ..." ; \
		curl -s "$$url" | ftm validate | alephclient write-entities -f "$$name" ; \
	done

rus_recent:
	ftm store delete -d opensanctions
	curl -s https://data.opensanctions.org/datasets/latest/all/entities.ftm.json | ftm store write -d opensanctions
	psql $(FTM_STORE_URI) < ./ru_recent_sanctions_2022.sql
	ftm store iterate -d ru_recent_sanctions_2022 | alephclient write-entities -f ru_recent_sanctions_2022


