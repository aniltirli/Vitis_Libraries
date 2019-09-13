#+-------------------------------------------------------------------------------
# The following parameters are assigned with default values. These parameters can
# be overridden through the make command line
#+-------------------------------------------------------------------------------

REPORT := no
PROFILE := no
DEBUG := no

#'estimate' for estimate report generation
#'system' for system report generation
ifneq ($(REPORT), no)
XOCC_FLAGS += --report estimate
XOCC_FLAGS += --report system
endif

#Generates profile summary report
ifeq ($(PROFILE), yes)
XOCC_FLAGS += --profile_kernel data:all:all:all
endif

#Generates debug summary report
ifeq ($(DEBUG), yes)
XOCC_FLAGS += --dk protocol:all:all:all
endif

#Checks for XILINX_SDX
ifndef XILINX_VITIS
ifndef XILINX_SDX
$(error XILINX_SDX variable is not set, please set correctly and rerun)
endif
endif
#   sanitize_dsa - create a filesystem friendly name from dsa name
#   $(1) - name of dsa
COLON=:
PERIOD=.
UNDERSCORE=_
sanitize_dsa = $(strip $(subst $(PERIOD),$(UNDERSCORE),$(subst $(COLON),$(UNDERSCORE),$(1))))

device2dsa = $(if $(filter $(suffix $(1)),.xpfm),$(shell $(XFCMP_DIR)/common/utility//parsexpmf.py $(1) dsa 2>/dev/null),$(1))
device2sandsa = $(call sanitize_dsa,$(call device2dsa,$(1)))
device2dep = $(if $(filter $(suffix $(1)),.xpfm),$(dir $(1))/$(shell $(XFCMP_DIR)/common/utility//parsexpmf.py $(1) hw 2>/dev/null) $(1),)

# Cleaning stuff
RM = rm -f
RMDIR = rm -rf

ECHO := @echo
