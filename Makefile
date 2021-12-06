.DEFAULT_GOAL := all
.SHELLFLAGS := -e -o pipefail -c
MAKEFLAGS += --warn-undefined-variables --no-builtin-rules
PATH := bin:node_modules/.bin:$(PATH)
SHELL := bash

DEPS_TARGETS := package-lock.json
SHELL_TARGETS := $(filter-out %/bash.template,$(shell git ls-files | xargs file --print0 -F '' {} + | grep --text -F 'shell script' | sed 's/\x00.*$$//'))
MARKDOWN_GLOBS := '**/*.md'
PRETTIER_GLOBS := '**/*.json' '**/*.md'
SHFMT_ARGS := -i 2 -ci -sr

.PHONY: all
## Build everything.
all: $(DEPS_TARGETS)
	$(MAKE) deps
	$(MAKE) check

.PHONY: check
## Check project for issues.
check: check-shellcheck check-markdownlint check-npm check-prettier check-shfmt

.PHONY: check-markdownlint
## Lint Markdown files.
check-markdownlint: require-markdownlint
	markdownlint --ignore-path .gitignore $(MARKDOWN_GLOBS)

.PHONY: check-npm
## Check for security issues in node.js dependencies.
check-npm: require-npm
	npm audit

.PHONY: check-prettier
## Check JSON, Markdown and YAML file formatting.
check-prettier: require-prettier
	prettier --ignore-path .gitignore --check $(PRETTIER_GLOBS)

.PHONY: check-shellcheck
## Lint shell scripts.
check-shellcheck: require-shellcheck
ifdef SHELL_TARGETS
	shellcheck -S warning $(SHELL_TARGETS)
endif

.PHONY: check-shfmt
## Check shell script formatting.
check-shfmt: require-shfmt
ifdef SHELL_TARGETS
	shfmt -d $(SHFMT_ARGS) $(SHELL_TARGETS)
endif

.PHONY: deps
## Install all local dependencies.
deps: deps-npm

.PHONY: deps-npm
## Install node.js based dependencies.
deps-npm: require-npm
	npm install

.SILENT: help
.PHONY: help
## This help screen.
help:
	# Extracts help from the Makefile itself, printing help for any rule
	# which matches the defined regular expression and that has a double
	# hash (##) comment on the line above.
	printf "Available Targets:\n\n"
	awk '/^[a-zA-Z\-_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "%-18s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' ${MAKEFILE_LIST} | grep --color=auto '^[^:]*'

.PHONY: fmt
## Reformat all files.
fmt: fmt-prettier fmt-shfmt

.PHONY: fmt-prettier
## Reformat JSON, Markdown and YAML files.
fmt-prettier: require-prettier
	prettier --ignore-path .gitignore --write $(PRETTIER_GLOBS)

.PHONY: fmt-shfmt
## Reformat shell script files.
fmt-shfmt: require-shfmt
ifdef SHELL_TARGETS
	shfmt -w $(SHFMT_ARGS) $(SHELL_TARGETS)
endif

package-lock.json: require-npm package.json
	npm update

REQUIREMENTS = $(addprefix require-,prettier markdownlint npm shellcheck shfmt)

.PHONY: $(REQUIREMENTS)
$(REQUIREMENTS): required=$(patsubst require-%,%,$@)
$(REQUIREMENTS): require-%:
	@command -v $(required) > /dev/null || \
		(printf "%s%s%s\n" "$$(tput setaf 3)" '"$(required)" is required, please install.' "$$(tput sgr0)"; exit 1)
