book_title ?= nouua
date = $(shell tool date)
# @todo[250123_050923] LaTeX exports.
publish:
	mkdir -p build/book && cp -r doc build/book
	pandoc -s \
		-c doc/style.css \
		--highlight-style highlight.theme \
		README.md > build/book/${book_title}.html
	cp robots.txt index.html build/book
	cd build && tar czvf ${date}_${book_title}_book.tar.gz book
read: publish
	firefox file://$(shell pwd)/build/${book_title}.html
clean:
	rm -rf build
