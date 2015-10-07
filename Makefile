site: site.hs
	stack build

build: site
	stack exec sencjw build

watch: build
	stack exec sencjw watch

publish: build
	cd _site ; git add -A ; git commit -m 'site update' ; git push origin master
