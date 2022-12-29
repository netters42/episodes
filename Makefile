all:
	mkdir -p public
	@echo "creating index.html"
	./episodes.sh > index.opml
	xsltproc -o public/index.html opml.xsl index.opml
	./podcast_feed.sh > public/հոսք.xml
	cp netters.png public/
	cp oblox.css public/

publish:
	scp public/* pingvinashen:/usr/local/www/netters/radio/htdocs/թողարկում/
