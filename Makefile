book_title ?= $(shell basename $(PWD))
# web_port ?= 8080
# control_port ?= 9090
web_port ?= 8008
control_port ?= 9009
ed ?= tmp-$(shell git branch --show-current)
export_dir ?= ~/tmp/${book_title}
date = $(shell tool date)
basename = ${ed}.${book_title}
container_name ?= ${basename}.$(shell hostname).$(shell date +%y%m%d_%H%M%S)
podman_ps = podman ps -a --noheading --format "{{.ID}}\t{{.Image}}\t{{.Names}}"
basename_filter = -fname='${basename}\..*' 
book_filter = -fname='.*\.${book_title}\.[^.]*\.[^.]*$$' 
name_filter = awk '{print$$3}'
id_filter = awk '{print$$1}'
status_filter = awk '{print$$3" \t"$$2}'
latest_container = $(shell ${podman_ps} ${basename_filter} -l | ${id_filter})
latest_container_name = $(shell ${podman_ps} ${basename_filter} -l | ${name_filter})
tag_filter = awk '{print$$2}'
latest_image ?= ${book_title}:$(shell podman image ls \
	| grep ${book_title} \
	| head -n1 \
	| ${tag_filter})
new_image ?= ${book_title}:${date}
doc ?= index.md
run:
	make build
	make new
latest:
	podman start -ia ${latest_container}
new:
	podman run -it \
		--name ${container_name} \
		--hostname ${container_name} \
		--volume .:/${book_title} \
		--volume ${HOME}/home:/root/home \
		--network slirp4netns:allow_host_loopback=true \
		--publish ${control_port}:${control_port} \
		--publish ${web_port}:${web_port} \
		--env NOUUA=/${book_title}/nouua \
		--env MUDPI_CONT=${container_name} \
		--env MUDPI_USER="$(shell whoami)" \
		--workdir /root \
		${podman_run_flags} ${latest_image} bash /${book_title}/init.sh
build:
	podman build -t ${new_image} .
rebuild-from:
	podman build -t ${new_image} --build-arg RERUNFROM=$(date) .
rebuild-all:
	podman build -t ${new_image} --no-cache .
# @todo[250105_165157] Container import target.
export-image:
	mkdir -p ${export_dir}
	podman export ${latest_container} \
		| gzip \
		| cat \
		> ${export_dir}/${date}.${latest_container_name}.tar.gz
old ?= root
new ?= $(shell git branch --show-current)
patch:
	mkdir -p build
	git diff ${old}..${new} > build/${date}_${old}_to_${new}.patch
html: ${doc}
	mkdir -p build/book
	cp -r doc build/book
	pandoc -s \
		-c doc/style.css \
		--highlight-style nouua/doc/highlight.theme \
		${doc} > build/book/${book_title}.html
# @todo[250123_050923] LaTeX exports.
# @todo[250123_223235] SVG to PNG conversion.
dbook = build/book
img_in = $(wildcard doc/images/*)
img_out = $(foreach img,$(img_in),$(dbook)/$(img).png)
pdf: ${doc}
slides: ${doc}
# @todo[250123_231718] Blame discussion entries.
publish: html pdf slides
	make -C nouua publish
	cp -r nouua/build/* build/book
	cd build && tar czvf ${date}_${book_title}_book.tar.gz book
read: publish
	firefox file://$(shell pwd)/build/book/nouua.html
browse: publish
	firefox file://$(shell pwd)/build/book/nouua.html
#	w3m file://$(shell pwd)/build/book/${book_title}.html
# @todo[250105_165004] Conventient container control and monitoring.
status:
	@echo "# Latest:"
	@ ${podman_ps} ${basename_filter} -l | ${status_filter}
	@echo "# All in this edition:"
	@ ${podman_ps} ${basename_filter} | ${status_filter}
	@echo "# Various other editions:"
	@ ${podman_ps} ${book_filter} | ${status_filter}
# @todo[250123_224528] In-tree artifact cleanup.
clean:
	make -C nouua clean
	rm -rf build
clean-cont:
	podman rm $(shell ${podman_ps} ${basename_filter} | ${id_filter})
clean-cont-all:
	podman rm $(shell ${podman_ps} ${book_filter} | ${id_filter})
# @todo[250124_035444] Removal of all @todo items for publishing.
detodo:
	sed -Ei '/@todo\[[0-9]{6}_[0-9]{6}\]/d' $(shell git ls-files)
.PHONY: iit build latest new clean status publish read detodo
