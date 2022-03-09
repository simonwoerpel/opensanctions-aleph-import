FROM alephdata/followthemoney

RUN apt-get -qq -y update && apt-get -qq -y install jq csvkit

COPY . /opensanctions
WORKDIR /opensanctions
CMD make all
