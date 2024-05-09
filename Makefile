build:
	# TODO

publish: build
	cd _site ; git add -A ; git commit -m 'site update' ; git push origin master
