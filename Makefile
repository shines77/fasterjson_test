
# Clear the default suffixes, so that built-in rules are not used.
.SUFFIXES :

SHELL := /bin/sh

CC := gcc
CXX := g++

# Configuration parameters.
DESTDIR =
BINDIR := $(DESTDIR)/usr/local/bin
INCLUDEDIR := $(DESTDIR)/usr/local/include
LIBDIR := $(DESTDIR)/usr/local/lib
DATADIR := $(DESTDIR)/usr/local/share
MANDIR := $(DESTDIR)/usr/local/share/man
srcroot :=
objroot := obj/gcc/linux/
binroot := bin/gcc/linux/

G_INCLUDE_DIR := -I$(srcroot)src -I$(srcroot)src/jimic -I$(srcroot)src/rapidjson -I$(srcroot)test
G_MMX_ENABLED := -msse -msse2 -msse3 -D__MMX__ -D__SSE__ -D__SSE2__ -D__SSE3__

# Build parameters. -m32 for x86 (32 bit), -m64 for x64 (64 bit)
CCFLAGS  := -Wall -w -pipe -g3 -fpermissive -fvisibility=hidden -O3 -funroll-loops $(G_INCLUDE_DIR) -D_GNU_SOURC $(G_MMX_ENABLED)
CXXFLAGS := -std=c++0x -Wall -w -pipe -g3 -fpermissive -fvisibility=hidden -O3 -funroll-loops $(G_INCLUDE_DIR) -D_REENTRANT -D_GNU_SOURC $(G_MMX_ENABLED)
LDFLAGS  :=
EXTRA_LDFLAGS :=
LIBS :=
# LIBS := -lpthread
RPATH_EXTRA :=
SO := so
IMPORTLIB := so
O := o
A := a
EXE :=
LIBPREFIX := lib
REV := 1
install_suffix :=
ABI := elf
XSLTPROC := /usr/bin/xsltproc
AUTOCONF := false
_RPATH = -Wl,-rpath,$(1)
RPATH = $(if $(1),$(call _RPATH,$(1)))

##########################################################################
#  See: http://stackoverflow.com/questions/714100/os-detecting-makefile  #
##########################################################################

ifeq ($(OS), Windows_NT)
    # LIBS += -lwinmm
    objroot := obj/gcc/mingw/
    binroot := bin/gcc/mingw/
else
    UNAME_S := $(shell uname -s)

    ifeq ($(UNAME_S), Linux)
        LIBS += -lrt
        CCCFLAGS += -D LINUX
        CXXFLAGS += -D LINUX
    endif
    ifeq ($(UNAME_S), Darwin)
        CCCFLAGS += -D OSX
        CXXFLAGS += -D OSX
        objroot := obj/gcc/darwin/
        binroot := bin/gcc/darwin/
    endif

    UNAME_P := $(shell uname -p)

    # x86_64|amd64|AMD64)
    ifeq ($(UNAME_P), x86_64)
        CCCFLAGS    += -m64 -D AMD64
        CXXFLAGS += -m64 -D AMD64
    endif
    # i[3456789]86|x86|i86pc)
    ifneq ($(filter %86, $(UNAME_P)),)
        CCCFLAGS += -m32 -D IA32
        CXXFLAGS += -m32 -D IA32
    endif
    # arm*)
    ifneq ($(filter arm%, $(UNAME_P)),)
        CCCFLAGS += -D ARM
        CXXFLAGS += -D ARM
        objroot := obj/gcc/arm/
        binroot := bin/gcc/arm/
    endif
endif

header_files := src/fasterjson.h src/jimic/jmc_time.h src/jimic/jmc_assert.h

enable_autogen := 0
enable_code_coverage := 0
enable_experimental := 1
enable_zone_allocator :=
DSO_LDFLAGS = -shared -Wl,-soname,$(@F)
SOREV = so.1
PIC_CFLAGS = -fPIC -DPIC
CTARGET = -o $@
LDTARGET = -o $@
MKLIB =
AR = ar
ARFLAGS = crus
CC_MM = 1
IS_STATIC_LIBS := 0

FASTERJSON_PRESS := fasterjson_press
FASTERJSON_TEST  := fasterjson_test
RAPIDJSON_TEST   := rapidjson_test

LIBFASTERJSON := $(LIBPREFIX)fasterjson(install_suffix)

# Lists of files.
BINS := $(srcroot)bin/pprof $(objroot)bin/gcc/linux/fasterjson_press.sh $(objroot)bin/gcc/linux/fasterjson_test.sh $(objroot)bin/gcc/linux/rapidjson_test.sh

C_HDRS := $(objroot)src/fasterjson.h $(objroot)src/jimic/jmc_time.h $(objroot)src/jimic/jmc_assert.h

C_SRCS := $(srcroot)test/fasterjson_press/press_fasterjson.c $(srcroot)src/fasterjson.c
# CXX_SRCS := $(srcroot)test/dummy.cpp
CXX_SRCS :=

C_TEST_SRCS := $(srcroot)test/fasterjson_test/test_fasterjson.c $(srcroot)src/fasterjson.c

CXX_RAPIDJSON_TEST_SRCS := $(srcroot)test/rapidjson_test/rapidjson_test.cpp

ifeq ($(IMPORTLIB),$(SO))
    STATIC_LIBS := $(objroot)lib/$(LIBFASTERJSON).$(A)
endif
ifdef PIC_CFLAGS
    STATIC_LIBS += $(objroot)lib/$(LIBFASTERJSON)_pic.$(A)
else
    STATIC_LIBS += $(objroot)lib/$(LIBFASTERJSON)_s.$(A)
endif
DSOS := $(objroot)lib/$(LIBFASTERJSON).$(SOREV)
ifneq ($(SOREV),$(SO))
    DSOS += $(objroot)lib/$(LIBFASTERJSON).$(SO)
endif

C_OBJS := $(C_SRCS:$(srcroot)%.c=$(objroot)fasterjson_press/%.$(O))
C_PIC_OBJS := $(C_SRCS:$(srcroot)%.c=$(objroot)fasterjson_press/%.pic.$(O))
C_JET_OBJS := $(C_SRCS:$(srcroot)%.c=$(objroot)fasterjson_press/%.jet.$(O))

CXX_OBJS := $(CXX_SRCS:$(srcroot)%.cpp=$(objroot)fasterjson_press/%.$(O))
CXX_PIC_OBJS := $(CXX_SRCS:$(srcroot)%.cpp=$(objroot)fasterjson_press/%.pic.$(O))
CXX_JET_OBJS := $(CXX_SRCS:$(srcroot)%.cpp=$(objroot)fasterjson_press/%.jet.$(O))

C_TEST_OBJS := $(C_TEST_SRCS:$(srcroot)%.c=$(objroot)fasterjson_test/%.$(O))
C_TEST_PIC_OBJS := $(C_TEST_SRCS:$(srcroot)%.c=$(objroot)fasterjson_test/%.pic.$(O))
C_TEST_JET_OBJS := $(C_TEST_SRCS:$(srcroot)%.c=$(objroot)fasterjson_test/%.jet.$(O))

CXX_RJTEST_OBJS := $(CXX_RAPIDJSON_TEST_SRCS:$(srcroot)%.cpp=$(objroot)rapidjson_test/%.$(O))
CXX_RJTEST_PIC_OBJS := $(CXX_RAPIDJSON_TEST_SRCS:$(srcroot)%.cpp=$(objroot)rapidjson_test/%.pic.$(O))
CXX_RJTEST_JET_OBJS := $(CXX_RAPIDJSON_TEST_SRCS:$(srcroot)%.cpp=$(objroot)rapidjson_test/%.jet.$(O))

.PHONY: all
.PHONY: fasterjson_press
.PHONY: fasterjson_test
.PHONY: rapidjson_test
.PHONY: help
.PHONY: clean

# Default target.
.PHONY: all
all: fasterjson_press fasterjson_test rapidjson_test

.PHONY: fasterjson_press
fasterjson_press: $(binroot)$(FASTERJSON_PRESS)$(EXE)

#
# Include generated dependency files.
#
ifdef CC_MM
    -include $(C_OBJS:%.$(O)=%.d)
    -include $(C_PIC_OBJS:%.$(O)=%.d)
    -include $(C_JET_OBJS:%.$(O)=%.d)

    -include $(CXX_OBJS:%.$(O)=%.d)
    -include $(CXX_PIC_OBJS:%.$(O)=%.d)
    -include $(CXX_JET_OBJS:%.$(O)=%.d)
endif

$(C_OBJS): $(objroot)fasterjson_press/%.$(O): $(srcroot)%.c
$(C_OBJS): CCFLAGS += -I$(srcroot)test -I$(srcroot)src
$(C_PIC_OBJS): $(objroot)fasterjson_press/%.pic.$(O): $(srcroot)%.c
$(C_PIC_OBJS): CCFLAGS += $(PIC_CFLAGS)
$(C_JET_OBJS): $(objroot)fasterjson_press/%.jet.$(O): $(srcroot)%.c
$(C_JET_OBJS): CCFLAGS += -DFASTERJSON_JET

$(CXX_OBJS): $(objroot)fasterjson_press/test/%.$(O): $(srcroot)test/%.cpp
$(CXX_OBJS): CXXFLAGS += -I$(srcroot)test -I$(srcroot)src
$(CXX_PIC_OBJS): $(objroot)fasterjson_press/test/%.pic.$(O): $(srcroot)test/%.cpp
$(CXX_PIC_OBJS): CXXFLAGS += $(PIC_CFLAGS)
$(CXX_JET_OBJS): $(objroot)fasterjson_press/test/%.jet.$(O): $(srcroot)test/%.cpp
$(CXX_JET_OBJS): CXXFLAGS += -DFASTERJSON_JET

ifneq ($(IMPORTLIB),$(SO))
    $(C_OBJS): CCFLAGS += -DDLLEXPORT
    $(CXX_OBJS): CXXFLAGS += -DDLLEXPORT
endif

ifndef CC_MM
    # Dependencies.
    HEADER_DIRS = $(srcroot)src $(srcroot)test $(srcroot)src/jimic $(srcroot)src/rapidjson
    HEADERS = $(wildcard $(foreach dir,$(HEADER_DIRS),$(dir)/*.h))
    $(C_OBJS) $(C_PIC_OBJS) $(C_JET_OBJS) $(CXX_OBJS) $(CXX_PIC_OBJS) $(CXX_JET_OBJS) : $(HEADERS)
endif

$(C_OBJS) $(C_PIC_OBJS) $(C_JET_OBJS) : %.$(O):
	@mkdir -p $(@D)
	$(CC) $(CCFLAGS) -c $(CTARGET) $<

ifneq ($(CXX_OBJS),)
$(CXX_OBJS) $(CXX_PIC_OBJS) $(CXX_JET_OBJS) : %.$(O):
    @mkdir -p $(@D)
    $(CXX) $(CXXFLAGS) -c $(CTARGET) $<
endif

ifneq ($(SOREV),$(SO))
%.$(SO) : %.$(SOREV)
	@mkdir -p $(@D)
	ln -sf $(<F) $@
endif

ifneq ($(CXX_SRCS),)
$(binroot)$(FASTERJSON_PRESS)$(EXE) : $(if $(PIC_CFLAGS),$(CXX_PIC_OBJS),$(CXX_OBJS)) $(if $(PIC_CFLAGS),$(C_PIC_OBJS),$(C_OBJS))
	@mkdir -p $(@D)
	$(CXX) $(LDTARGET) $(filter %.$(O),$^) $(call RPATH,$(objroot)lib) $(LDFLAGS) $(filter-out -lm,$(LIBS)) -lm $(EXTRA_LDFLAGS)
else
$(binroot)$(FASTERJSON_PRESS)$(EXE) : $(if $(PIC_CFLAGS),$(C_PIC_OBJS),$(C_OBJS))
	@mkdir -p $(@D)
	$(CC) $(LDTARGET) $(filter %.$(O),$^) $(call RPATH,$(objroot)lib) $(LDFLAGS) $(filter-out -lm,$(LIBS)) -lm $(EXTRA_LDFLAGS)
endif

.PHONY : fasterjson_press

.PHONY: fasterjson_test
fasterjson_test: $(binroot)$(FASTERJSON_TEST)$(EXE)

#
# Include generated dependency files.
#
ifdef CC_MM
-include $(C_TEST_OBJS:%.$(O)=%.d)
-include $(C_TEST_PIC_OBJS:%.$(O)=%.d)
-include $(C_TEST_JET_OBJS:%.$(O)=%.d)
endif

ifneq ($(IMPORTLIB),$(SO))
    $(C_TEST_OBJS): CCFLAGS += -DDLLEXPORT
endif

$(C_TEST_OBJS): $(objroot)fasterjson_test/%.$(O): $(srcroot)%.c
$(C_TEST_OBJS): CCFLAGS += -I$(srcroot)test -I$(srcroot)src
$(C_TEST_PIC_OBJS): $(objroot)fasterjson_test/%.pic.$(O): $(srcroot)%.c
$(C_TEST_PIC_OBJS): CCFLAGS += $(PIC_CFLAGS)
$(C_TEST_JET_OBJS): $(objroot)fasterjson_test/%.jet.$(O): $(srcroot)%.c
$(C_TEST_JET_OBJS): CCFLAGS += -DFASTERJSON_JET

ifndef CC_MM
    # Dependencies.
    TEST_HEADER_DIRS = $(srcroot)src $(srcroot)test $(srcroot)src/jimic $(srcroot)src/rapidjson
    TEST_HEADERS = $(wildcard $(foreach dir,$(TEST_HEADER_DIRS),$(dir)/*.h))
    $(C_TEST_OBJS) $(C_TEST_PIC_OBJS) $(C_TEST_JET_OBJS) : $(TEST_HEADERS)
endif

$(C_TEST_OBJS) $(C_TEST_PIC_OBJS) $(C_TEST_JET_OBJS) : %.$(O):
	@mkdir -p $(@D)
	$(CC) $(CCFLAGS) -c $(CTARGET) $<

ifneq ($(SOREV),$(SO))
%.$(SO) : %.$(SOREV)
	@mkdir -p $(@D)
	ln -sf $(<F) $@
endif

$(binroot)$(FASTERJSON_TEST)$(EXE) : $(if $(PIC_CFLAGS),$(C_TEST_PIC_OBJS),$(C_TEST_OBJS))
	@mkdir -p $(@D)
	$(CC) $(LDTARGET) $(filter %.$(O),$^) $(call RPATH,$(objroot)lib) $(LDFLAGS) $(filter-out -lm,$(LIBS)) -lm $(EXTRA_LDFLAGS)

.PHONY : fasterjson_test

.PHONY: rapidjson_test
rapidjson_test: $(binroot)$(RAPIDJSON_TEST)$(EXE)

#
# Include generated dependency files.
#
ifdef CC_MM
-include $(CXX_RJTEST_OBJS:%.$(O)=%.d)
-include $(CXX_RJTEST_PIC_OBJS:%.$(O)=%.d)
-include $(CXX_RJTEST_JET_OBJS:%.$(O)=%.d)
endif

ifneq ($(IMPORTLIB),$(SO))
    $(CXX_RJTEST_OBJS): CXXFLAGS += -DDLLEXPORT
endif

$(CXX_RJTEST_OBJS): $(objroot)rapidjson_test/%.$(O): $(srcroot)%.cpp
$(CXX_RJTEST_OBJS): CXXFLAGS += -I$(srcroot)test -I$(srcroot)src -I$(srcroot)src/rapidjson
$(CXX_RJTEST_PIC_OBJS): $(objroot)rapidjson_test/%.pic.$(O): $(srcroot)%.cpp
$(CXX_RJTEST_PIC_OBJS): CXXFLAGS += $(PIC_CFLAGS)
$(CXX_RJTEST_JET_OBJS): $(objroot)rapidjson_test/%.jet.$(O): $(srcroot)%.cpp
$(CXX_RJTEST_JET_OBJS): CXXFLAGS += -DRAPIDJSON_JET

ifndef CC_MM
    # Dependencies.
    RJTEST_HEADER_DIRS = $(srcroot)src $(srcroot)test $(srcroot)src/jimic $(srcroot)src/rapidjson
    RJTEST_HEADERS = $(wildcard $(foreach dir,$(RJTEST_HEADER_DIRS),$(dir)/*.h))
    $(CXX_RJTEST_OBJS) $(CXX_RJTEST_PIC_OBJS) $(CXX_RJTEST_JET_OBJS) : $(RJTEST_HEADERS)
endif

$(CXX_RJTEST_OBJS) $(CXX_RJTEST_PIC_OBJS) $(CXX_RJTEST_JET_OBJS) : %.$(O):
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $(CTARGET) $<

ifneq ($(SOREV),$(SO))
%.$(SO) : %.$(SOREV)
	@mkdir -p $(@D)
	ln -sf $(<F) $@
endif

$(binroot)$(RAPIDJSON_TEST)$(EXE) : $(if $(PIC_CFLAGS),$(CXX_RJTEST_PIC_OBJS),$(CXX_RJTEST_OBJS))
	@mkdir -p $(@D)
	$(CXX) $(LDTARGET) $(filter %.$(O),$^) $(call RPATH,$(objroot)lib) $(LDFLAGS) $(filter-out -lm,$(LIBS)) -lm $(EXTRA_LDFLAGS)

.PHONY : rapidjson_test


#=============================================================================
# Target rules for targets named Fasterjson_press

# Help Target
help:
	@echo "The following are some of the valid targets for this Makefile:"
	@echo "... all (the default if no target is provided)"
	@echo "... clean"
	@echo "... fasterjson_press"
	@echo "... fasterjson_test"
	@echo "... rapidjson_test"
	@echo "... help"
.PHONY : help

# The main clean target
clean:
	rm -f $(C_OBJS)
ifneq ($(C_DEP_OBJS),)
	rm -f $(C_DEP_OBJS)
endif
	rm -f $(C_PIC_OBJS)
	rm -f $(C_JET_OBJS)
	rm -f $(C_OBJS:%.$(O)=%.d)
	rm -f $(C_OBJS:%.$(O)=%.gcda)
	rm -f $(C_OBJS:%.$(O)=%.gcno)
ifneq ($(C_DEP_OBJS),)
	rm -f $(C_DEP_OBJS:%.$(O)=%.d)
	rm -f $(C_DEP_OBJS:%.$(O)=%.gcda)
	rm -f $(C_DEP_OBJS:%.$(O)=%.gcno)
endif
	rm -f $(C_PIC_OBJS:%.$(O)=%.d)
	rm -f $(C_PIC_OBJS:%.$(O)=%.gcda)
	rm -f $(C_PIC_OBJS:%.$(O)=%.gcno)
	rm -f $(C_JET_OBJS:%.$(O)=%.d)
	rm -f $(C_JET_OBJS:%.$(O)=%.gcda)
	rm -f $(C_JET_OBJS:%.$(O)=%.gcno)

ifneq ($(CXX_SRCS),)
	rm -f $(CXX_OBJS)
ifneq ($(CXX_DEP_OBJS),)
	rm -f $(CXX_DEP_OBJS)
endif
	rm -f $(CXX_PIC_OBJS)
	rm -f $(CXX_JET_OBJS)
	rm -f $(CXX_OBJS:%.$(O)=%.d)
	rm -f $(CXX_OBJS:%.$(O)=%.gcda)
	rm -f $(CXX_OBJS:%.$(O)=%.gcno)
ifneq ($(CXX_DEP_OBJS),)
	rm -f $(CXX_DEP_OBJS:%.$(O)=%.d)
	rm -f $(CXX_DEP_OBJS:%.$(O)=%.gcda)
	rm -f $(CXX_DEP_OBJS:%.$(O)=%.gcno)
endif
	rm -f $(CXX_PIC_OBJS:%.$(O)=%.d)
	rm -f $(CXX_PIC_OBJS:%.$(O)=%.gcda)
	rm -f $(CXX_PIC_OBJS:%.$(O)=%.gcno)
	rm -f $(CXX_JET_OBJS:%.$(O)=%.d)
	rm -f $(CXX_JET_OBJS:%.$(O)=%.gcda)
	rm -f $(CXX_JET_OBJS:%.$(O)=%.gcno)
endif

	rm -f $(C_TEST_OBJS)
	rm -f $(C_TEST_PIC_OBJS)
	rm -f $(C_TEST_JET_OBJS)
	rm -f $(C_TEST_OBJS:%.$(O)=%.d)
	rm -f $(C_TEST_OBJS:%.$(O)=%.gcda)
	rm -f $(C_TEST_OBJS:%.$(O)=%.gcno)
	rm -f $(C_TEST_PIC_OBJS:%.$(O)=%.d)
	rm -f $(C_TEST_PIC_OBJS:%.$(O)=%.gcda)
	rm -f $(C_TEST_PIC_OBJS:%.$(O)=%.gcno)
	rm -f $(C_TEST_JET_OBJS:%.$(O)=%.d)
	rm -f $(C_TEST_JET_OBJS:%.$(O)=%.gcda)
	rm -f $(C_TEST_JET_OBJS:%.$(O)=%.gcno)

	rm -f $(CXX_RJTEST_OBJS)
	rm -f $(CXX_RJTEST_PIC_OBJS)
	rm -f $(CXX_RJTEST_JET_OBJS)
	rm -f $(CXX_RJTEST_OBJS:%.$(O)=%.d)
	rm -f $(CXX_RJTEST_OBJS:%.$(O)=%.gcda)
	rm -f $(CXX_RJTEST_OBJS:%.$(O)=%.gcno)
	rm -f $(CXX_RJTEST_PIC_OBJS:%.$(O)=%.d)
	rm -f $(CXX_RJTEST_PIC_OBJS:%.$(O)=%.gcda)
	rm -f $(CXX_RJTEST_PIC_OBJS:%.$(O)=%.gcno)
	rm -f $(CXX_RJTEST_JET_OBJS:%.$(O)=%.d)
	rm -f $(CXX_RJTEST_JET_OBJS:%.$(O)=%.gcda)
	rm -f $(CXX_RJTEST_JET_OBJS:%.$(O)=%.gcno)

ifneq ($(IS_STATIC_LIBS),0)
	rm -f $(DSOS) $(STATIC_LIBS)
endif
	rm -f $(objroot)*.gcov.*

.PHONY : clean
#=============================================================================
