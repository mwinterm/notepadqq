# Convenience wrapper – delegates to CMake in the build/ directory.
# Run ./configure first to generate the build system.

BUILD_DIR := build
NPROC := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

.PHONY: all install clean distclean

all:
	@if [ ! -f "$(BUILD_DIR)/CMakeCache.txt" ]; then \
		echo "ERROR: Build not configured. Run ./configure first."; \
		exit 1; \
	fi
	cmake --build $(BUILD_DIR) -j$(NPROC)

install:
	cmake --install $(BUILD_DIR)

clean:
	@if [ -d "$(BUILD_DIR)" ]; then cmake --build $(BUILD_DIR) --target clean; fi

distclean:
	rm -rf $(BUILD_DIR) out
