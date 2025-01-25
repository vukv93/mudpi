book_title ?= nouua
doc ?= index.md
html: ${doc}
	mkdir -p build && cp -r doc build
	pandoc -s \
		-c doc/style.css \
		--highlight-style doc/highlight.theme \
		${doc} > build/${book_title}.html
# @todo[250123_050923] LaTeX exports.
pdf: ${doc}
slides: ${doc}
publish: html pdf slides
read: publish
	firefox file://$(shell pwd)/build/${book_title}.html
clean:
	rm -rf build
