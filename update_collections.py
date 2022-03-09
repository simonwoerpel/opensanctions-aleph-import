import requests
from alephclient.api import AlephAPI


aleph = AlephAPI()
url = "https://data.opensanctions.org/datasets/latest/index.json"
res = requests.get(url)
collections = res.json()["datasets"]

for collection in collections:
    aleph_collection = aleph.get_collection_by_foreign_id(collection["name"])
    data = {
        "label": collection["title"],
        "summary": (collection["description"] + "\n\n" + collection["summary"]).strip(),
        "publisher": collection.get("publisher", {}).get("name"),
        "publisher_url": collection.get("publisher", {}).get("url"),
        # "countries": [c["code"] for c in collection["targets"]["countries"]],
        "data_url": collection.get("data", {}).get("url"),
        "category": "sanctions",
        "frequency": "daily"
    }
    try:
        if aleph_collection is not None:
            aleph.update_collection(aleph_collection["collection_id"], data)
        else:
            aleph.create_collection({**data, **{"foreign_id": collection["name"]}})
    except Exception as e:
        print(collection["name"], e)
        print(data)
