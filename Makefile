libs = -package-db .cabal-sandbox/x86_64-osx-ghc-7.6.3-packages.conf.d 
site: site.hs
	ghc $(libs) --make site.hs
