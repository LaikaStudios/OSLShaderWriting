#
#   Copyright 2023 Laika, LLC. Authored by Mitch Prater.
# 
#   Licensed under the Apache License Version 2.0 http://apache.org/licenses/LICENSE-2.0,
#   or the MIT license http://opensource.org/licenses/MIT, at your option.
# 
#   This program may not be copied, modified, or distributed except according to those terms.
#

#
# PIXAR_ROOT must be set to the location of the
# RenderMan installation: e.g. /opt/pixar
#
ifndef PIXAR_ROOT
    $(error PIXAR_ROOT has not been set. This is required for the build system to function.)
endif

#
# Control variables determine what is made.
#
# Which RenderMan software version(s) are built if one
# isn't specified in the RMAN_VERSION environment variable.
# Used to build multiple RenderMan versions.
rman_versions := 25.2

# Different version builds cannot be run in parallel.
.NOTPARALLEL:

# SUBDIRS directories will be made using their own Makefile.
SUBDIRS := osl

# CURDIR is set by the make system itself: it is not part of the environment.
# It is the preferred means of acquiring the location where make was invoked:
# https://www.gnu.org/software/make/manual/make.html#Recursion
SRCDIR ?= $(CURDIR)
export SRCDIR

PYTHONDIR ?= $(SRCDIR)/python3
export PYTHONDIR

# Build destination. This is where the made files end up.
DSTDIR ?= $(SRCDIR)/build
export DSTDIR

#
# Default goal: the target of 'make'.
#
.DEFAULT_GOAL = all

# The default target's prerequisites.
all : $(DSTDIR) subdirs copydirs

# Targets that depend on $(DSTDIR)
subdirs copydirs : $(DSTDIR)

# Targets whose time stamps we want to ignore.
.PHONY : all info clean subdirs copydirs $(rman_versions)


#------------------------------------------------------------------
# Makefile functionaliy.
#	Make all contents and install it in the DSTDIR.
#	Sub-directories are made using their own Makefile.
#------------------------------------------------------------------
# Ensure the destination directory exists.
$(DSTDIR) :
	mkdir -p $(DSTDIR)

# Handle directories whose contents are not built but simply copied.
COPY_CMD = cp -arv

copydirs : $(DSTDIR)

#
# If the RMAN_VERSION environment variable is undefined, then for each member
# of $(rman_versions), define that version as RMAN_VERSION and run make.
# That's all this ifndef section does.
#
ifndef RMAN_VERSION
    .PHONY : $(rman_versions)
    $(rman_versions) :
		@ echo "---------------------------------------------------------------"
		@ echo "PRMan Version: $@"
		@ $(MAKE) --no-print-directory $(MAKECMDGOALS) RMAN_VERSION=$@

    all clean : $(rman_versions)
else

#
# The actual work of building is done in the sub-directories.
#
.PHONY : subdirs $(SUBDIRS) clean $(CLEAN_SUBDIRS)

subdirs: $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@


# Cleans the subdirectories.
CLEAN_SUBDIRS = $(addprefix clean_, $(SUBDIRS))

clean_subdirs : $(CLEAN_SUBDIRS)
$(CLEAN_SUBDIRS):
	$(MAKE) -C $(subst clean_,,$@) clean_local

# Top-level clean also nukes the build directory.
clean : clean_subdirs
	@ echo "make clean."
	@ -rm -rf $(SRCDIR)/build

endif

#
# Helpful rules.
#
help :
	@ echo "------------------------------------------------------------------------"
	@ echo "PIXAR_ROOT must be set to the location of the RenderMan installation:"
	@ echo "e.g. /opt/pixar"
	@ echo "RMAN_VERSION can also be set to the RenderMan version you wish to make:"
	@ echo "e.g. 25.0"
	@ echo ""
	@ echo "If RMAN_VERSION is not set, the rman_versions variable specified"
	@ echo "in this Makefile will be used to build all the versions it lists."
	@ echo ""
	@ echo "Current settings:"
	@ echo "PIXAR_ROOT: $(PIXAR_ROOT)"
	@ echo "RMAN_VERSION:  $(RMAN_VERSION)"
	@ echo "rman_versions: $(rman_versions)"
	@ echo "SRCDIR:     $(SRCDIR)"
	@ echo "PYTHONDIR:  $(PYTHONDIR)"
	@ echo "DSTDIR:     $(DSTDIR)"
	@ echo "SUBDIRS:    $(SUBDIRS)"
	@ echo "------------------------------------------------------------------------"
	@ echo "Once the shaders have been built, you can run"
	@ echo "make testrender"
	@ echo "to render a test image of a teapot with pattern_FractaNoise on it."
