TARGET=_site
POSTS_DIR=$(TARGET)/posts
CSS_DIR=$(TARGET)/css
IMG_DIR=$(TARGET)/images

# Markdown compiler of choice
MC=pandoc
MC_FLAGS=--from=markdown --to=html

post_sources := $(wildcard posts/*.markdown)
post_htmls := $(patsubst %.markdown,$(TARGET)/%.html,$(post_sources))

css_sources := $(wildcard css/*.css)
css_targets := $(patsubst css/%.css,_site/css/%.css,$(css_sources))

img_sources := $(shell find -E images -maxdepth 1 -type f -regex ".*(png|jpg|svg)")
img_targets := $(patsubst images/%,_site/images/%,$(img_sources))


################################################################################
## MAIN

build: $(post_htmls) $(css_targets) $(img_targets)


################################################################################
## DIRECTORIES

$(TARGET):
	mkdir $(TARGET)

$(POSTS_DIR): $(TARGET)
	mkdir $(POSTS_DIR)

$(CSS_DIR): $(TARGET)
	mkdir $(CSS_DIR)

$(IMG_DIR): $(TARGET)
	mkdir $(IMG_DIR)


################################################################################
## HTML (posts)

$(TARGET)/posts/%.html: posts/%.markdown $(TARGET) $(POSTS_DIR)
	$(MC) $(MC_FLAGS) $< > $@.tmp
	src/mkpost.sh $< $@.tmp $@
	rm $@.tmp


################################################################################
## CSS

$(TARGET)/css/%.css: css/%.css $(CSS_DIR)
	cp $< $@


################################################################################
## IMAGES

$(img_targets): $(img_sources)
	cp -a images _site/images


################################################################################
## MISC

publish: build
	cd _site ; git add -A ; git commit -m 'site update' ; git push origin master

clean:
	rm -rf $(TARGET)

serve:
	cd _site && ruby -run -e httpd . -p 9090
