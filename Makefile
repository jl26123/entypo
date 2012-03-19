dist: font html

font: ttf2eot
	./bin/fontbuild.py \
		-c ./config.yml \
		-t ./src/font_template.sfd \
		-i ./src/svg \
		-o ./font/entypo.ttf
	./bin/fontconvert.py -i ./font/entypo.ttf -o ./font
	./support/ttf2eot/ttf2eot < ./font/entypo.ttf >./font/entypo.eot

ttf2eot:
	cd ./support/ttf2eot && \
		$(MAKE) $@

ttfautohint:
	# TODO: add qmake and onther build tools test
	cd ./support/ttfautohint \
		&& ./bootstrap \
		&& ./configure \
		&& make

html: font
	./bin/parse_template.py -c ./config.yml ./src/css.mustache ./font/entypo.css
	./bin/parse_template.py -c ./config.yml ./src/demo.mustache ./font/demo.html

dev-deps:
	if test 0 -ne `id -u` ; then \
		echo "root priveledges are required" >&2 ; \
		exit 128 ; \
		fi
	apt-get -qq install \
		fontforge python python-fontforge \
		python-argparse python-yaml python-pip \
		build-essential \
		qt4-qmake
	pip -q install pystache


.SILENT: dev-deps
