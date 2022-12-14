.PHONY: build configure install doc

## Silent by default
V =
ifeq ($(strip $(V)),)
        E = @echo
        Q = @
else
        E = @\#
        Q =
endif
export E Q

PWD:=$(shell pwd)
SCRIPTS_DIR:=$(PWD)/scripts/
include $(PWD)/../config.mk

# These file lists are for generating dummy headers for c compilation
PASS_TEST_COGENT_FILES := $(wildcard tests/pass_*.cogent)
FAIL_TEST_COGENT_FILES := $(wildcard tests/fail_*.cogent)
DUMMY_HEADER_FILES := $(addprefix tests/include/,$(notdir $(PASS_TEST_COGENT_FILES:.cogent=_dummy.h)))

all: .sandbox .cabal-update .install-deps .configure .install
	$(E) "Cogent Compiler successfully built for $(OS)."
	$(E)
	$(E) "Add 'cogent' compiler to your path by running:"
	$(E) '  export PATH=$(PWD)/.cabal-sandbox/bin/:$$PATH'
	$(E)
	$(E) "To enable bash auto-completion for 'cogent', please add the following to your .bashrc file:"
	$(E) "source $(PWD)/misc/cogent_autocomplete.sh"
	$(E)
	$(E)


stack-build:
	$(E) "Building Cogent using stack."
	$(STACK) build

.sandbox:
ifneq ($(wildcard .cabal-sandbox/),)
	$(E) "Using Existing sandbox..."
else
	$(E) "Building in a sandbox..."
	$(CABAL) sandbox init
	$(CABAL) sandbox add-source ../isa-parser
endif

.install-deps:
	$(E) "Installing dependencies"
	$(CABAL) install --only-dependencies

.configure:
	$(E) "Configuring..."
	$(CABAL) configure $(CONFIG_FLAGS)

.build:
	$(E) "Building..."
	$(CABAL) build $(BUILD_FLAGS)
	$(CABAL) copy

.install:
	$(E) "Installing.."
	$(CABAL) install $(INSTALL_FLAGS)

doc:
	$(E) "Building Cogent docs..."
	$(Q) make -C doc

clean:
	$(Q) make -C doc clean
	$(Q) rm -rf out/
	$(Q) rm -rf tests/include
	$(Q) find . -name "*_flymake.hs" -delete

full-clean: clean
	$(Q) $(CABAL) clean
	$(Q) $(CABAL) sandbox delete -v0
	$(Q) rm -rf .cabal-sandbox/ dist/ ../isa-parser/dist


dev: .sandbox .cabal-update .install-deps .configure .build
	$(E) "Cogent Compiler successfully built for $(OS)."
	$(E)
	$(E) "Add 'cogent' compiler to your path by running:"
	$(E) '  export PATH=$(PWD)/dist/build/cogent:$$PATH'
	$(E)
	$(E) "_Or_ make a symlink to the executable in ~/.cabal/bin by running:"
	$(E) '  ln -s $(PWD)/dist/build/cogent/cogent $$HOME/.cabal/bin/cogent' 
	$(E)
	$(E) "To enable bash auto-completion for 'cogent', please add the following to your .bashrc file:"
	$(E) "source $(PWD)/misc/cogent_autocomplete.sh"
	$(E)
	$(E)

.cabal-update:
	$(CABAL) update

tests/include/%_dummy.h: tests/%.cogent
	$(Q) egrep "^type +([A-Z][a-zA-Z0-9_']*)( [a-z][a-zA-Z0-9_']*)* *(--.*)?$$" $^ | sed -e "s/type \([A-Z][a-zA-Z0-9_']*\).*$$/typedef void* \1;/" > $@

.gen-types: .test-setup $(DUMMY_HEADER_FILES)
	$(E) "Generated C headers."

.test-setup:
	$(Q)mkdir -p tests/include

tests: test-clean .test-cogent test-tc test-ds test-an test-mn test-cg \
	test-tc-proof test-aq test-aq test-shallow-proof test-ee test-gcc

test-clean:
	$(E) "Cleaning up artefacts from earlier test runs."
	$(Q) rm -rf out/
	$(Q) rm -rf tests/include/

.test-cogent:
ifeq ($(shell which cogent 2> /dev/null; echo $$? ),1)
	$(error Cogent not installed, or is not available in your PATH)
endif

test-tc: .gen-types
	$(E) "=== Type Checking Tests ==="
	$(SCRIPTS_DIR)/cogent_validate.sh -tc

test-ds: .gen-types
	$(E) "=== Desugaring Tests ==="
	$(SCRIPTS_DIR)/cogent_validate.sh -ds

test-an: .gen-types
	$(E) "=== A-normal transform Tests ==="
	$(SCRIPTS_DIR)/cogent_validate.sh -an

test-mn: .gen-types
	$(E) "=== Monomorphization Tests ==="
	$(SCRIPTS_DIR)/cogent_validate.sh -mn

test-cg: .gen-types
	$(E) "=== Code Generation Tests ==="
	$(SCRIPTS_DIR)/cogent_validate.sh -cg

test-tc-proof: .gen-types
	$(E) "=== Proof Generation For Type Checking Tests ==="
	$(SCRIPTS_DIR)/cogent_validate.sh -tc-proof

test-ac: .gen-types
	$(E) "=== Isabelle (AutoCorres) test ==="
	$(SCRIPTS_DIR)/cogent_validate.sh -ac

test-ffi-gen: .gen-types
	$(E) "=== FFI-generator Tests ==="
	$(SCRIPTS_DIR)/cogent_validate.sh -ffi-gen

test-aq: .gen-types
	$(E) "=== Anti-quotation Tests ==="
	$(SCRIPTS_DIR)/cogent_validate.sh -aq

test-shallow-proof: .gen-types
	$(E) "=== Shallow-embedding Proofs Tests ==="
	$(SCRIPTS_DIR)/cogent_validate.sh -shallow-proof

test-goanna:
	$(E) "=== Goanna test ==="
	$(error Goanna tests are not currently supported.)
	$(SCRIPTS_DIR)/cogent_validate.sh -goanna

test-ee: .gen-types
	$(E) "=== End-to-End Proofs Tests ==="
	$(SCRIPTS_DIR)/cogent_validate.sh -ee

test-gcc: .gen-types
	$(E) "=== Compile generated code using GCC ==="
	$(SCRIPTS_DIR)/cogent_validate.sh -gcc

test-libgum:
	$(E) "=== Typechecking libgum ==="
	$(SCRIPTS_DIR)/cogent_validate.sh -libgum

examples: .test-cogent
	$(E) "=== Build Cogent examples ==="
	$(SCRIPTS_DIR)/build_examples.sh

examples-clean:
	$(E) "=== Build Cogent examples ==="
	$(SCRIPTS_DIR)/build_examples.sh clean

help:
	$(E) "** Cogent Compiler **"
	$(E) "Run 'make' to build the Cogent compiler."
	$(E) ""
	$(E) "* make"
	$(E) "  Install Cogent in a cabal-sandbox"
	$(E) ""
	$(E) "* make dev"
	$(E) "  Build Cogent with a cabal-sandbox"
	$(E) ""
	$(E) "* make clean"
	$(E) "  Cleanup"
	$(E) ""
	$(E) "* make full-clean"
	$(E) "  Cleanup (removes sandbox)."
	$(E) ""
	$(E) "* make tests"
	$(E) "  Run all tests."
	$(E) ""
	$(E) "* make tests"
	$(E) "  Run all tests."
	$(E) ""
	$(E) "* make test-clean"
	$(E) "  Cleanup artefacts from earlier test runs."
	$(E) ""
	$(E) "* make test-tc"
	$(E) "  Run Typechecking Tests."
	$(E) ""
	$(E) "* make test-ds"
	$(E) "  Run Desugaring Tests."
	$(E) ""
	$(E) "* make test-an"
	$(E) "  Run A-Normalisation Tests."
	$(E) ""
	$(E) "* make test-mn"
	$(E) "  Run Monomorphisation Tests."
	$(E) ""
	$(E) "* make test-cg"
	$(E) "  Run Code Generation Tests."
	$(E) ""
	$(E) "* make test-tc-proof"
	$(E) "  Run Typechecking Proof Generation Tests."
	$(E) ""
	$(E) "* make test-ac"
	$(E) "  Run AutoCorres test."
	$(E) ""
	$(E) "* make test-ffi-gen"
	$(E) "  Run FFI-generator Tests."
	$(E) ""
	$(E) "* make test-aq"
	$(E) "  Run Anti-Quotation Tests."
	$(E) ""
	$(E) "* make test-shallow-proof"
	$(E) "  Run Shallow Embedding Proofs Tests."
	$(E) ""
	$(E) "* make test-goanna"
	$(E) "  Run Goanna Test [Currently Not Supported]."
	$(E) ""
	$(E) "* make test-ee"
	$(E) "  Run End-to-End Proofs Tests."
	$(E) ""
	$(E) "* make test-gcc"
	$(E) "  Compile generated code using GCC."
	$(E) ""
	$(E) "* make test-libgum"
	$(E) "  Run libgum Typechecking Tests."
	$(E) ""
	$(E) "* make examples"
	$(E) "  Compile Cogent examples."
	$(E) ""
	$(E) "* make examples-clean"
	$(E) "  Clean up earlier build of examples."
	$(E) ""
	$(E) "* make doc"
	$(E) "  Build Cogent docs."
	$(E) ""
	$(E) "* make help"
	$(E) "  Print this help."

