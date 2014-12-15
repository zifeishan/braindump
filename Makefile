# Makefile for MindReporter

.PHONY: build
build:
	@echo "=== Creating symbolic links into ${HOME}/local/bin/mindreporter... ==="
	rm -f ${HOME}/local/bin/mindreporter
	rm -rf ${HOME}/local/mindreporter
	ln -s `pwd`/mindreporter.sh ${HOME}/local/bin/mindreporter
	ln -s `pwd`/mindreporter ${HOME}/local/mindreporter

	@echo "\n=== Verifying installation... ==="
	@if [ -f ${HOME}/local/bin/mindreporter ]; then \
		echo "SUCCESS! Mindreporter binary has been put into ${HOME}/local/bin."; \
	else \
		echo "FAILED: Cannot extract into ${HOME}/local/bin."; \
		exit 1; \
	fi 
	

# .PHONY: test
# test: 
# 	@echo "\n=== Testing MindReporter modules... ==="
# 	./test.sh

# .PHONY: all
# all: build test

.DEFAULT_GOAL:= build # `make` only do installation for now. 
											# testing needs `make test` on users' will

