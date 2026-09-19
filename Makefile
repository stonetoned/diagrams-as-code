DGRAC := ./dgrac
DGRAC_VERSION := $(strip $(shell cat VERSION))
IMAGE_NAME ?= dgrac:$(DGRAC_VERSION)
CONTAINER_NAME ?= dgrac-dev

DIAGRAMS_HOST_LOCATION ?= $(CURDIR)/diagrams
OUTPUT_HOST_LOCATION ?= $(CURDIR)/output
KROKI_URL ?= https://kroki.io

PREFIX ?= $(HOME)/.local
BINDIR ?= $(PREFIX)/bin
BASH_COMPLETION_DIR ?= $(PREFIX)/share/bash-completion/completions
ZSH_COMPLETION_DIR ?= $(PREFIX)/share/zsh/site-functions

DOC_EXAMPLES_HOST_LOCATION ?= $(CURDIR)/docs/assets/examples
DOCS_SOURCE_LOCATION ?= $(CURDIR)/docs
DOCS_BUILD_DIRECTORY ?= _site
DOCS_BASE_URL ?= /diagrams-as-code
DOCS_HOST ?= 0.0.0.0
DOCS_PORT ?= 4000

.PHONY: help setup clean run-container stop-container doctor list render render-all test test-cli \
	test-static generate-py generate-puml generate-mermaid generate-dot generate-d2 \
	diagrams-py diagrams-uml diagrams-mermaid diagrams-dot diagrams-d2 \
	dgrac-py dgrac-uml dgrac-mermaid dgrac-dot dgrac-d2 \
	sync-doc-examples refresh-docs version install install-script install-completion \
	docs-build docs-serve

help:
	@$(DGRAC) help
	@printf '\nMake shortcuts:\n'
	@printf '  make render engine=mermaid filename=architecture\n'
	@printf '  make render-all | test | doctor | list\n'
	@printf '  make refresh-docs | docs-build | docs-serve\n'
	@printf '  make install PREFIX=$$HOME/.local\n'

setup:
	docker build -t "$(IMAGE_NAME)" .

run-container: setup
	@mkdir -p "$(OUTPUT_HOST_LOCATION)"
	@docker rm -f "$(CONTAINER_NAME)" >/dev/null 2>&1 || true
	docker run -d \
		--security-opt no-new-privileges \
		--cap-drop ALL \
		-e KROKI_URL="$(KROKI_URL)" \
		-v "$(DIAGRAMS_HOST_LOCATION):/diagrams:ro" \
		-v "$(OUTPUT_HOST_LOCATION):/output" \
		--name "$(CONTAINER_NAME)" "$(IMAGE_NAME)"

stop-container:
	@docker rm -f "$(CONTAINER_NAME)" >/dev/null 2>&1 || true

clean: stop-container

doctor:
	@DGRAC_KROKI_URL="$(KROKI_URL)" $(DGRAC) doctor

list:
	@$(DGRAC) list --source "$(DIAGRAMS_HOST_LOCATION)"

render:
	@[ -n "$(engine)" ] && [ -n "$(filename)" ] || { \
		echo 'usage: make render engine=<py|puml|mermaid|dot|d2> filename=<name> [inputext=<ext>]' >&2; \
		exit 2; \
	}
	@DGRAC_KROKI_URL="$(KROKI_URL)" $(DGRAC) render \
		--source "$(DIAGRAMS_HOST_LOCATION)" \
		--output "$(OUTPUT_HOST_LOCATION)" \
		--engine "$(engine)" \
		--name "$(filename)" \
		$(if $(inputext),--ext "$(inputext)",)

generate-py:
	@$(MAKE) render engine=py filename="$(filename)" inputext="$${inputext:-py}"

generate-puml:
	@$(MAKE) render engine=puml filename="$(filename)" inputext="$${inputext:-puml}"

generate-mermaid:
	@$(MAKE) render engine=mermaid filename="$(filename)" inputext="$${inputext:-mmd}"

generate-dot:
	@$(MAKE) render engine=dot filename="$(filename)" inputext="$${inputext:-dot}"

generate-d2:
	@$(MAKE) render engine=d2 filename="$(filename)" inputext="$${inputext:-d2}"

diagrams-py dgrac-py: generate-py
diagrams-uml dgrac-uml: generate-puml
diagrams-mermaid dgrac-mermaid: generate-mermaid
diagrams-dot dgrac-dot: generate-dot
diagrams-d2 dgrac-d2: generate-d2

render-all:
	@DGRAC_KROKI_URL="$(KROKI_URL)" $(DGRAC) render-all \
		--source "$(DIAGRAMS_HOST_LOCATION)" \
		--output "$(OUTPUT_HOST_LOCATION)"

test-cli:
	@sh tests/cli_test.sh

test-static:
	@sh tests/static_test.sh

test: test-cli test-static
	@DGRAC_KROKI_URL="$(KROKI_URL)" $(DGRAC) test \
		--source "$(DIAGRAMS_HOST_LOCATION)" \
		--output "$(OUTPUT_HOST_LOCATION)"

sync-doc-examples:
	@set -e; \
	for engine in py uml mermaid dot d2; do \
		mkdir -p "$(DOC_EXAMPLES_HOST_LOCATION)/$$engine"; \
		find "$(DOC_EXAMPLES_HOST_LOCATION)/$$engine" -type f -name '*.png' -delete; \
		if [ -d "$(OUTPUT_HOST_LOCATION)/$$engine" ]; then \
			find "$(OUTPUT_HOST_LOCATION)/$$engine" -type f -name '*.png' -exec cp -f {} "$(DOC_EXAMPLES_HOST_LOCATION)/$$engine/" \; ; \
		fi; \
	done

refresh-docs: render-all sync-doc-examples

docs-build:
	@mkdir -p "$(DOCS_SOURCE_LOCATION)"
	docker run --rm \
		-v "$(DOCS_SOURCE_LOCATION):/srv/jekyll" \
		-e BASE_URL="$(DOCS_BASE_URL)" \
		jekyll/jekyll:4.2.2 sh -lc 'gem install --no-document jekyll-theme-minimal jekyll-sitemap >/dev/null && \
			jekyll build --source /srv/jekyll --destination /srv/jekyll/$(DOCS_BUILD_DIRECTORY) --config /srv/jekyll/_config.yml --baseurl "$$BASE_URL" --trace'

docs-serve:
	@mkdir -p "$(DOCS_SOURCE_LOCATION)"
	@echo "Serving docs at http://localhost:$(DOCS_PORT)$(DOCS_BASE_URL)/"
	docker run --rm \
		-v "$(DOCS_SOURCE_LOCATION):/srv/jekyll" \
		-e BASE_URL="$(DOCS_BASE_URL)" \
		-p "$(DOCS_HOST):$(DOCS_PORT):$(DOCS_PORT)" \
		jekyll/jekyll:4.2.2 sh -lc 'gem install --no-document jekyll-theme-minimal jekyll-sitemap >/dev/null && \
			jekyll serve --host 0.0.0.0 --port $(DOCS_PORT) --source /srv/jekyll --destination /srv/jekyll/$(DOCS_BUILD_DIRECTORY) --config /srv/jekyll/_config.yml --baseurl "$$BASE_URL" --livereload --trace'

version:
	@cat VERSION

install-script:
	install -d "$(BINDIR)"
	install -m 0755 dgrac "$(BINDIR)/dgrac"

install-completion:
	install -d "$(BASH_COMPLETION_DIR)" "$(ZSH_COMPLETION_DIR)"
	install -m 0644 completions/dgrac.bash "$(BASH_COMPLETION_DIR)/dgrac"
	install -m 0644 completions/_dgrac "$(ZSH_COMPLETION_DIR)/_dgrac"

install: install-script install-completion
	@echo "installed dgrac $(DGRAC_VERSION) to $(BINDIR)/dgrac"
