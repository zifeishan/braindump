# Makefile for BrainDump

.PHONY: build
build:
	@echo "=== Creating symbolic links into ${HOME}/local/bin/braindump... ==="
	rm -f ${HOME}/local/bin/braindump
	rm -f ${HOME}/local/bin/braindump-configure
	rm -rf ${HOME}/local/braindump
	mkdir -p ${HOME}/local/bin
	ln -s `pwd`/braindump.sh ${HOME}/local/bin/braindump
	ln -s `pwd`/util/config-generator/generate.py ${HOME}/local/bin/braindump-configure
	ln -s `pwd`/util ${HOME}/local/braindump

	@echo "\n=== Verifying installation... ==="
	@if [ -f "${HOME}/local/bin/braindump" ]; then \
		echo "SUCCESS! BrainDump binary has been put into ${HOME}/local/bin/braindump"; \
		echo "Util directory has been put into ${HOME}/local/braindump/"; \
		echo "Configure script has been put into ${HOME}/local/bin/braindump-configure"; \
	else \
		echo "FAILED: Cannot extract into ${HOME}/local/bin."; \
		exit 1; \
	fi 
	

# .PHONY: test
# test: 
# 	@echo "\n=== Testing braindump modules... ==="
# 	./test.sh

# .PHONY: all
# all: build test

.DEFAULT_GOAL:= build # `make` only do installation for now. 
											# testing needs `make test` on users' will

