# This file needs GNU make
#generated by: makedep -v OS=Linux;;FORT=pgi;;FORMAT=big_endian -o Makefile assim.F90

#---------#
#  Rules  #
#---------#

.f90.o:
	$(F90C) $(F90FLAGS) -c $<

.F90.o:
	$(F90C) $(F90FLAGS) -c $<

%.o: %.F90
	$(F90C) $(F90FLAGS) -c $<

.SUFFIXES: $(SUFFIXES) .f90 .F90

#-------------------------------#
#  Platform specific variables  #
#-------------------------------#

include config.mk

# default settings
# If you need to adapt, OS and FORT, then make the corresponding changes in config.mk

OS ?= Linux

FORT ?= gfortran

FORMAT ?= big_endian

PRECISION ?= double
USE_MPIF90 ?= on
MPI ?= 
OPENMP ?= 
DEBUG ?= 
JOBS ?= 1

OAK_SONAME ?= liboak.so.1

OAK_LIBNAME ?= liboak.a

include Compilers/$(OS)-$(strip $(FORT)).mk
include Compilers/libs.mk

#---------#
#  assim  #
#---------#

ASSIM_PROG ?= assim

ASSIM_SRCS = anamorphosis.F90 assim.F90 assimilation.F90 date.F90 grids.F90 \
	initfile.F90 matoper.F90 matoper2.F90 ndgrid.F90 parall.F90 rrsqrt.F90 \
	ufileformat.F90

ASSIM_OBJS = anamorphosis.o assim.o assimilation.o date.o grids.o initfile.o \
	matoper.o matoper2.o ndgrid.o parall.o rrsqrt.o ufileformat.o match.o

MODULES = anamorphosis.mod  assimilation.mod  date.mod  grids.mod  initfile.mod  \
        matoper.mod  ndgrid.mod  parall.mod  rrsqrt.mod  ufileformat.mod

#-----------------#
#  Common macros  #
#-----------------#

PROG = $(ASSIM_PROG)

SRCS = $(ASSIM_SRCS)

OBJS = $(ASSIM_OBJS)

#-------------------#
#  Standard tagets  #
#-------------------#



all: $(PROG)

clean:
	rm -f $(PROG) $(OBJS) $(MODULES)

lib: $(OBJS)
	ar rs $(OAK_LIBNAME) $(OBJS)

dynlib: $(OBJS)
	@if test $$(getconf LONG_BIT) = 64 -a ! "$(PIC)"; then \
	  echo "Warning: Your system seems to be 64-bit and PIC is not activated. Creating dynamic libraries will probaly fail."; \
	  echo "Use 'make PIC=on ...' or set PIC=on in config.mk"; \
        fi 
	$(CC) -shared -Wl,-soname,$(OAK_SONAME) -o $(OAK_SONAME) $(OBJS) $(LIBS) $(FRTLIB)

allbin:
	make -j $(JOBS) FORT=$(FORT) DEBUG=on clean
	make -j $(JOBS) FORT=$(FORT) DEBUG=on all
	make -j $(JOBS) FORT=$(FORT) DEBUG=on OPENMP=on clean
	make -j $(JOBS) FORT=$(FORT) DEBUG=on OPENMP=on all
	make -j $(JOBS) FORT=$(FORT) DEBUG=on MPI=on clean
	make -j $(JOBS) FORT=$(FORT) DEBUG=on MPI=on all


# create install directories (if needed)

$(OAK_LIBDIR):
	$(MKDIR_P) $(OAK_LIBDIR)

$(OAK_INCDIR):
	$(MKDIR_P) $(OAK_INCDIR)

$(OAK_BINDIR):
	$(MKDIR_P) $(OAK_BINDIR)

install: all $(OAK_LIBDIR) $(OAK_INCDIR) $(OAK_BINDIR)
	cp $(PROG) $(OAK_BINDIR)
	if [ -e $(OAK_LIBNAME) ]; then cp $(OAK_LIBNAME) $(OAK_LIBDIR); fi
	if [ -e $(OAK_SONAME) ]; then cp $(OAK_SONAME) $(OAK_LIBDIR); fi
	cp $(MODULES) $(OAK_INCDIR)

print:
	echo $(LIBS) $(F90FLAGS) $(PRECISION) $(OAK_DIR)

#---------------#
#  Executables  #
#---------------#

$(ASSIM_PROG): $(ASSIM_OBJS) 
	$(F90C) $(LDFLAGS) -o $@ $(ASSIM_OBJS) $(LIBS)

#----------------#
#  Dependencies  #
#----------------#

assim.o: assim.F90 assimilation.o initfile.o matoper.o rrsqrt.o ufileformat.o \
	ppdef.h

ndgrid.o: ndgrid.F90 matoper.o ufileformat.o ppdef.h

parall.o: parall.F90 ppdef.h

matoper.o: matoper.F90 ppdef.h

matoper2.o: matoper.o matoper2.F90

date.o: date.F90 ppdef.h

anamorphosis.o: anamorphosis.F90 initfile.o ufileformat.o ppdef.h

grids.o: grids.F90 ppdef.h

initfile.o: initfile.F90 ppdef.h

rrsqrt.o: rrsqrt.F90 matoper.o parall.o ufileformat.o ppdef.h

assimilation.o: assimilation.F90 anamorphosis.o date.o grids.o initfile.o \
	matoper.o ndgrid.o parall.o rrsqrt.o ufileformat.o ppdef.h

ufileformat.o: ufileformat.F90 ppdef.h

match.o: match.c
