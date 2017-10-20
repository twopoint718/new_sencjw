watch:
	stack exec sencjw -- watch

build:
	stack exec sencjw build

publish: build
	cd _site ; git add -A ; git commit -m 'site update' ; git push origin master
