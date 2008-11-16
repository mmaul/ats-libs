######
MAKE=gmake
ATSCC="$(ATSHOME)/bin/atscc"
ATSOPT="$(ATSHOME)/bin/atsopt"
######
all: bdb

.PHONY: bdb
bdb:
	cd bdb; $(MAKE)
