curl https://raw.githubusercontent.com/EBISPOT/efo/master/src/ontology/efo-edit.owl > imports/efo-edit.owl
echo -ne '\n'
echo -ne '\n'
echo -ne '|               |   (0%)\r'
sleep 1
robot template --prefix "OBI: http://purl.obolibrary.org/obo/OBI_" --prefix "EFO: http://www.ebi.ac.uk/efo/EFO_" --prefix "UO: http://purl.obolibrary.org/obo/UO_" --prefix "GO: http://purl.obolibrary.org/obo/GO_" --prefix "CL: http://purl.obolibrary.org/obo/CL_" --prefix "PATO: http://purl.obolibrary.org/obo/PATO_" --template imports/annotare_terms.tsv --output build/annotare_terms.owl && echo -ne '|#####               |   (25%)\r'
sleep 1
robot query --input build/annotare_terms.owl --query sparql/annotate.sparql build/annotare_annotate.owl && echo -ne '|##########          |   (50%)\r'
sleep 1
robot merge --input imports/efo-edit.owl --input build/annotare_annotate.owl --output build/efo-edit.owl && echo -ne '|###############     |   (75%)\r'
sleep 1
robot verify -i build/efo-edit.owl --queries sparql/obsolete.sparql -O reports/  && echo -ne '|####################|   (100%)\r'
echo -ne '\n'
