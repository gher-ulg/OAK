# name of executable


ASSIM_PROG ?= assim-$(FORT)-$(PRECISION)

ifdef MPI
  ASSIM_PROG := $(ASSIM_PROG)-mpi
endif

ifdef OPENMP
  ASSIM_PROG := $(ASSIM_PROG)-openmp
endif

ifdef DEBUG
  ASSIM_PROG := $(ASSIM_PROG)-debug
endif

ifdef EXEC_SUFFIX
  ASSIM_PROG := $(ASSIM_PROG)-$(EXEC_SUFFIX)
endif

ifdef PROFILING
  ASSIM_PROG := $(ASSIM_PROG)-profiling
  F90FLAGS += $(PROFILING_F90FLAGS)
  LDFLAGS += $(PROFILING_LDFLAGS)
endif




#
# Library locations
#

# If all libraries are in one folder

INCDIR ?=
LIBDIR ?=

# netCDF configuration

NETCDF_CONFIG ?= nc-config
NETCDF_INCDIR ?= $(INCDIR)
NETCDF_LIBDIR ?= $(LIBDIR)
NETCDF_LIB ?= -lnetcdf

# MPI configuration

MPIF90 ?= mpif90
MPI_INCDIR ?= $(INCDIR)
MPI_LIBDIR ?= $(LIBDIR)
MPI_LIB ?= -llamf77mpi -lmpi -llam -lutil -lpthread -ldl

# LAPACK configuration

LAPACK_LIBDIR ?= $(LIBDIR)
LAPACK_LIB ?= -llapack

# BLAS configuration

BLAS_LIBDIR ?= $(LIBDIR)
BLAS_LIB ?= -lblas

# Extra parameters

EXTRA_F90FLAGS ?=
EXTRA_LDFLAGS ?=



# MPI

ifdef MPI
ifdef USE_MPIF90
  F90C := $(MPIF90)
  F90FLAGS += -DASSIM_PARALLEL
else
  F90FLAGS += -I$(MPI_INCDIR)

  # use MPI_LIBDIR only if it is non-empty
  ifneq ($(strip $(MPI_LIBDIR)),)
    LIBS += -L$(MPI_LIBDIR)
  endif
  LIBS += $(MPI_LIB)
endif

ifeq ($(PRECISION),double)
  F90FLAGS += -DDEFAULT_REAL=MPI_DOUBLE_PRECISION 
else
  F90FLAGS += -DDEFAULT_REAL=MPI_REAL
endif

endif

# LAPACK
# use LAPACK_LIBDIR only if it is non-empty

ifneq ($(strip $(LAPACK_LIBDIR)),)
  LIBS += -L$(LAPACK_LIBDIR)
endif
LIBS += $(LAPACK_LIB)

# BLAS
# use BLAS_LIBDIR only if it is non-empty

ifneq ($(strip $(BLAS_LIBDIR)),)
  LIBS += -L$(BLAS_LIBDIR)
endif
LIBS += $(BLAS_LIB)



# netCDF library
# * use nc-config script if present (full path can be specified with 
# NETCDF_CONFIG environement variable)
# * if not use variables NETCDF_LIBDIR, NETCDF_INCDIR and NETCDF_LIB

NETCDF_VERSION := $(shell $(NETCDF_CONFIG) --version)

### check presense of nc-config script
ifeq ($(NETCDF_VERSION),)
  F90FLAGS += -I$(NETCDF_INCDIR)

  # use NETCDF_LIBDIR only if it is non-empty
  ifneq ($(strip $(NETCDF_LIBDIR)),)
    LIBS += -L$(NETCDF_LIBDIR)
  endif
  LIBS += $(NETCDF_LIB)
else
  F90FLAGS += -I$(shell $(NETCDF_CONFIG) --includedir)
  LIBS += $(shell $(NETCDF_CONFIG) --flibs)
endif


F90FLAGS += $(EXTRA_F90FLAGS)
LDFLAGS += $(EXTRA_LDFLAGS)
