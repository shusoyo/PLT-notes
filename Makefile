PNAME := 01-pfpl 02-plfa 03-tapl

PROOT := $(shell pwd)
SYNCF_PATH := $(PROOT)/pdfs/

TYPST_FLAGS := --root $(PROOT) --font-path ./result --ignore-system-fonts

all: $(PNAME)
	@echo "All projects updated."

.PHONY: all $(PNAME)

font:
	@echo "Building fonts with Nix..."
	@nix flake update
	@nix build
	@echo "Fonts build complete."
	
$(PNAME):
	@echo "Processing project: $@"
	@mkdir -p "$(SYNCF_PATH)/$@"
	
	@if [ -f "$@/main.typ" ]; then \
		typst c "$@/main.typ" "$(SYNCF_PATH)/$@.pdf" $(TYPST_FLAGS); \
	fi
