all:
	xsltproc -o index.html opml.xsl index.opml

publish:
	scp * pingvinashen:/usr/local/www/netters/radio/htdocs/դրուագ/
