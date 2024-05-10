# Build temp (target) dir TODO: e.g. use `mktemp -d`
TARGET=tmp
POSTS_DIR=$(TARGET)/posts

# Markdown compiler of choice
MC=pandoc
MC_FLAGS=--from=markdown --to=html

post_sources := $(wildcard posts/*.markdown)
post_htmls := $(patsubst %.markdown,$(TARGET)/%.html,$(post_sources))

build: $(post_htmls)

$(TARGET)/posts/%.html: posts/%.markdown $(TARGET) $(POSTS_DIR)
	$(MC) $(MC_FLAGS) $< > $@.tmp
	src/mkpost.sh $< $@.tmp $@
	rm $@.tmp

$(TARGET):
	mkdir $(TARGET)

$(POSTS_DIR): $(TARGET)
	mkdir $(POSTS_DIR)

clean:
	rm -rf $(POSTS_DIR)/*html

publish: build
	cd _site ; git add -A ; git commit -m 'site update' ; git push origin master
