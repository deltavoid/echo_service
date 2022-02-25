


PACKAGE_NAME=echo-service
PACKAGE_FULL_NAME=echo-service_0.1.0_amd64.deb




BUILD_DIR ?= build
.PHONY: build clean run
default: run


build: $(BUILD_DIR)/Makefile
	cd $(BUILD_DIR) && make --trace

$(BUILD_DIR)/Makefile: Makefile
	mkdir -p $(BUILD_DIR) \
	&& cmake -S . -B $(BUILD_DIR) 
	

clean:	
	rm -rf $(BUILD_DIR)


run: build
	$(BUILD_DIR)/main hello world

ldd: build
	ldd $(BUILD_DIR)/main



build_deb:
	./mkdeb.sh


install:
	dpkg -i $(PACKAGE_FULL_NAME)

uninstall:
	dpkg -r $(PACKAGE_NAME)


start:
	systemctl start echo

test:
	/usr/local/echo_service/bin/client 127.0.0.1 8192 1 3 
