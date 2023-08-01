#
#   Copyright 2022-2023 Laika, LLC. Authored by Mitch Prater.
# 
#   Licensed under the Apache License Version 2.0 http://apache.org/licenses/LICENSE-2.0,
#   or the MIT license http://opensource.org/licenses/MIT, at your option.
# 
#   This program may not be copied, modified, or distributed except according to those terms.
#

#
# PIXAR_ROOT and RMAN_VERSION are required to be set.
#
ifndef PIXAR_ROOT
    $(error PIXAR_ROOT has not been set. This is required for the build system to function.)
endif
ifndef RMAN_VERSION
    $(error RMAN_VERSION has not been set. This must be done by the top-level Makefile, the environment, or in the 'make' command)
endif

# Set RMANTREE is if isn't already.
RMANTREE ?= $(PIXAR_ROOT)/RenderManProServer-$(RMAN_VERSION)


#------------------------------------------------------------------
# Make functionality.
#	.oso files are made in-place from their .osl file.
#	The .oso files are then installed to $(install_dir)
#	with their flattened base name for USD compatibility.
#------------------------------------------------------------------
#
# SUBDIRS and EXCLUDE control variables determine which .osl files are made.
#
# These directories will be searched for .osl files.
SUBDIRS := convert data displace dot osl pattern space texture trace util

# These shaders won't be built: directory/basename
EXCLUDE := 

# SUBDIRS and EXCLUDE functionality.
#	$(src) is the list of .osl files to build from.
#	$(oso) is the list of .oso files to build.
src := $(foreach dir,$(SUBDIRS),$(wildcard $(dir)/*.osl))

EXCLUDE := $(basename $(EXCLUDE))
EXCLUDE := $(addsuffix .osl, $(EXCLUDE))

src := $(filter-out $(EXCLUDE), $(src))
oso := $(src:%.osl=%.oso)

# Relevant make system directories.
SRCDIR ?= ..
PYTHONDIR ?= $(SRCDIR)/python3

# Location to install the flattened shaders:
# $(SRCDIR)/build/
# └── $(RMAN_VERSION)
#     └── shaders
#         ├── flattened_ShaderName.oso
#         └── ...
DSTDIR ?= $(SRCDIR)/build
install_dir := $(DSTDIR)/${RMAN_VERSION}/shaders

#
# Default goal: the target of 'make'.
#
.DEFAULT_GOAL = all

# Targets whose time stamps we want to ignore.
.PHONY : all clean install

# The default target's prerequisites.
all : install $(oso)

# The installation requires $(install_dir) to exist.
install : $(install_dir)

# Don't worry if $(install_dir) already exists, just make it.
$(install_dir) : 
	@ mkdir -p $(install_dir)

#
# Compiler settings.
#
CC = ${RMANTREE}/bin/oslc
CFLAGS = 

INCLUDE = -I. -I./include

#
# Shader build rules.
#

# Individual dependencies.
util/Add.osl : util/UI.h
util/Mix.osl : util/UI.h
util/Mul.osl : util/UI.h
util/Sub.osl : util/UI.h

%.oso : %.osl
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ $<
	env python3 $(PYTHONDIR)/install_shaders.py --copy $(install_dir) $@


#
# Clean rules.
#
clean_local:
	@ echo "osl directory clean."
	@ -rm -f $(shell find -L . -name "*.oso" -print)

clean: clean_local
	@ -rm -f $(shell find -L $(install_dir) -name "*.oso" -print)


#
# Helpful rules.
#
help:
	@ echo "------------------------------------------------------------------------"
	@ echo "PIXAR_ROOT must be set to the location of the RenderMan installation:"
	@ echo "e.g. /opt/pixar"
	@ echo "RMAN_VERSION must be set to the RenderMan version you wish to make:"
	@ echo "e.g. 25.0"
	@ echo ""
	@ echo "Current settings:"
	@ echo "PIXAR_ROOT: $(PIXAR_ROOT)"
	@ echo "RMAN_VERSION: $(RMAN_VERSION)"
	@ echo "RMANTREE:   $(RMANTREE)"
	@ echo "CURDIR:     $(CURDIR)"
	@ echo "PYTHONDIR:  $(PYTHONDIR)"
	@ echo "DSTDIR:     $(DSTDIR)"
	@ echo "build dir:  $(install_dir)"
	@ echo "------------------------------------------------------------------------"

show_src:
	@ echo "The source .osl files to compile:"
	@ echo $(src) | sed "s/ /\\n/g" | sort
	@ echo ""

show_oso:
	@ echo "The target .oso files to build:"
	@ echo $(oso) | sed "s/ /\\n/g" | sort
	@ echo ""
	@ echo "The built .oso files that exist in the osl directory tree:"
	@ find -L . -name "*.oso" -print | sort
	@ echo ""

show_build:
	@ echo "The installed .oso files:"
	@ find -L $(install_dir) -name "*.oso" -print | sort
	@ echo ""
