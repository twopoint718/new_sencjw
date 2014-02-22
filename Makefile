libs = -package-db .cabal-sandbox/x86_64-osx-ghc-7.6.3-packages.conf.d 
site: site.hs
	ghc $(libs) --make site.hs

build: site
	./site build

publish: build
	cd _site
	git commit -am 'site update'
	git push origin master
	cd ..
