######
#
#
#
######
MAKE=gmake
ATSCC="$(ATSHOME)/bin/atscc"
ATSOPT="$(ATSHOME)/bin/atsopt"

######


VERSION=1.0.1
CPPFLAGS += -I/usr/local/include/db47 -I$(ATSHOME)/ccomp/runtime/ -I$(ATSHOME)/ -I.
LDFLAGS += -L$(ATSHOME)/ccomp/lib -lats -L/usr/local/lib/db47 -ldb-4.7

######
all:  lib/libats_bdb.a lib/libats_bdb.so test/bdb_test

obj/bdb_sats.c: SATS/bdb.sats
	$(ATSOPT) $(CPPFLAGS) -o $@ -s $^

obj/bdb_sats.o: obj/bdb_sats.c
	 gcc  $(CPPFLAGS) -o $@ -c $^

obj/bdb.o:C/bdb.c
	gcc -fPIC $(CPPFLAGS) -o $@ -c $^

lib/libats_bdb.a: obj/bdb.o obj/bdb_sats.o
	ar cr $@ $^

lib/libats_bdb.so: obj/bdb.o obj/bdb_sats.o
	gcc -shared -Wl,-soname,$@.$(VERSION) \
        -o $@.$(VERSION)  $^
	rm -f $@; 
	ln -s ./$@.$(VERSION) $@

test/bdb_test: lib/libats_bdb.a
	cd test; \
        $(ATSCC) $(CPPFLAGS) -o bdb_test  -D_ATS_GCATS -O3  bdb_test.dats $(LDFLAGS) -L../lib  -lats_bdb; \
        ./bdb_test ; \

######

clean:: ; rm -f bdb obj/* lib/* test/*.c test/bdb_test test/my.db test/*~ SATS/*~ DATS/*~ C/*~ CATS/*~ *~

###### end of [Makefile] ######
