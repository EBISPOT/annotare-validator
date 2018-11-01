#!/bin/bash

mkdir imports/
mkdir build/
echo -ne '\n'
echo -ne 'Downloading Annotare and EFO...'
echo -ne '\n'
sleep 1
curl https://raw.githubusercontent.com/arrayexpress/annotare2/b70b8c7bb70f2fbf45aac40b579f195aaf8cac49/app/webapp/src/main/resources/Annotare-default.properties > ./imports/annotare-default.properties 
curl https://raw.githubusercontent.com/EBISPOT/efo/master/src/ontology/efo-edit.owl > imports/efo-edit.owl
echo -ne '\n'
echo -ne 'Running tests...'
echo -ne '\n'
echo -ne '|                    |   (0%)\r'
sleep 1
awk '/_/ {print $3}' ./imports/annotare-default.properties > ./build/annotare_all_terms.tsv && echo -ne '|##                  |   (12%)\r'
sleep 1
awk '!/array/ {print}' ./build/annotare_all_terms.tsv > ./build/annotare_terms.tsv && echo -ne '|#####               |   (25%)\r'
sleep 1
cat ./templates/ID.tsv ./build/annotare_terms.tsv > ./build/at.tmp && mv ./build/at.tmp ./build/annotare_terms.tsv && echo -ne '|#######             |   (37%)\r'
sleep 1
sed 's/_/:/' ./build/annotare_terms.tsv > ./build/annotare.tsv && echo -ne '|##########          |   (50%)\r'
sleep 1
bin/robot template --prefix "OBI: http://purl.obolibrary.org/obo/OBI_" --prefix "EFO: http://www.ebi.ac.uk/efo/EFO_" --prefix "UO: http://purl.obolibrary.org/obo/UO_" --prefix "GO: http://purl.obolibrary.org/obo/GO_" --prefix "CL: http://purl.obolibrary.org/obo/CL_" --prefix "PATO: http://purl.obolibrary.org/obo/PATO_" --template build/annotare.tsv --output build/annotare_terms.owl  && echo -ne '|############        |   (62%)\r'
sleep 1
bin/robot query --input build/annotare_terms.owl --query sparql/annotate.sparql build/annotare_annotate.owl  && echo -ne '|###############     |   (75%)\r'
sleep 1
bin/robot merge --input imports/efo-edit.owl --input build/annotare_annotate.owl --output build/efo-edit.owl && echo -ne '|#################   |   (87%)\r'
sleep 1
#bin/robot verify -i build/efo-edit.owl --queries sparql/obsolete.sparql -O reports/  && echo -ne '|####################|   (100%)\r'
