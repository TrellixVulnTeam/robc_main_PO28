# Generated automatically from Makefile.in by configure.
# Makefile.in generated automatically by automake 1.4-p5 from Makefile.am

# Copyright (C) 1994, 1995-8, 1999, 2001 Free Software Foundation, Inc.
# This Makefile.in is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.


SHELL = /bin/sh

srcdir = .
top_srcdir = ..
prefix = /usr/local
exec_prefix = ${prefix}

bindir = ${exec_prefix}/bin
sbindir = ${exec_prefix}/sbin
libexecdir = ${exec_prefix}/libexec
datadir = ${prefix}/share
sysconfdir = ${prefix}/etc
sharedstatedir = ${prefix}/com
localstatedir = ${prefix}/var
libdir = ${exec_prefix}/lib
infodir = ${prefix}/info
mandir = ${prefix}/man
includedir = ${prefix}/include
oldincludedir = /usr/include

DESTDIR =

pkgdatadir = $(datadir)/crack-attack
pkglibdir = $(libdir)/crack-attack
pkgincludedir = $(includedir)/crack-attack

top_builddir = ..

ACLOCAL = aclocal
AUTOCONF = autoconf
AUTOMAKE = automake
AUTOHEADER = autoheader

INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL} $(AM_INSTALL_PROGRAM_FLAGS)
INSTALL_DATA = ${INSTALL} -m 644
INSTALL_SCRIPT = ${INSTALL_PROGRAM}
transform = s,x,x,

NORMAL_INSTALL = :
PRE_INSTALL = :
POST_INSTALL = :
NORMAL_UNINSTALL = :
PRE_UNINSTALL = :
POST_UNINSTALL = :
CC = gcc
CXX = c++
MAKEINFO = /home/rcarreon/games/crack-attack-1.1.10/missing makeinfo
PACKAGE = crack-attack
VERSION = 1.1.10

pkgdata_DATA = clock_0.tga clock_1.tga clock_2.tga clock_3.tga clock_4.tga clock_5.tga clock_6.tga clock_7.tga clock_8.tga clock_9.tga clock_extra.tga count_down_1.tga count_down_2.tga count_down_3.tga count_down_go.tga default_record flavor_1.tga flavor_2.tga font0_0.tga font0_1.tga font0_2.tga font0_3.tga font0_4.tga font0_5.tga font0_6.tga font0_7.tga font0_8.tga font0_9.tga font0_a.tga font0_and.tga font0_at.tga font0_b.tga font0_br.tga font0_c.tga font0_ca.tga font0_cb.tga font0_cc.tga font0_cd.tga font0_ce.tga font0_cf.tga font0_cg.tga font0_ch.tga font0_ci.tga font0_cj.tga font0_ck.tga font0_cl.tga font0_cln.tga font0_cm.tga font0_cma.tga font0_cn.tga font0_co.tga font0_cp.tga font0_cq.tga font0_cr.tga font0_cs.tga font0_ct.tga font0_cu.tga font0_cv.tga font0_cw.tga font0_cx.tga font0_cy.tga font0_cz.tga font0_d.tga font0_ds.tga font0_e.tga font0_ep.tga font0_eq.tga font0_f.tga font0_g.tga font0_gt.tga font0_h.tga font0_i.tga font0_j.tga font0_k.tga font0_l.tga font0_lt.tga font0_m.tga font0_mn.tga font0_n.tga font0_o.tga font0_p.tga font0_pd.tga font0_pe.tga font0_pl.tga font0_pr.tga font0_ps.tga font0_pu.tga font0_q.tga font0_qm.tga font0_r.tga font0_s.tga font0_sl.tga font0_t.tga font0_td.tga font0_u.tga font0_v.tga font0_w.tga font0_x.tga font0_y.tga font0_z.tga font0_za.tga font0_zb.tga font0_zc.tga font0_zd.tga garbage_flavor_000.tga garbage_flavor_001.tga garbage_flavor_002.tga garbage_flavor_003.tga garbage_flavor_004.tga garbage_flavor_005.tga garbage_flavor_logo.tga garbage_flavor_logo_x.tga garbage_lightmap_0.tga garbage_lightmap_1.tga garbage_lightmap_2.tga garbage_lightmap_3.tga garbage_lightmap_4.tga garbage_lightmap_5.tga logo.tga logo_x.tga message_anykey.tga message_game_over.tga message_loser.tga message_paused.tga message_waiting.tga message_winner.tga sign_10.tga sign_11.tga sign_12.tga sign_4.tga sign_5.tga sign_6.tga sign_7.tga sign_8.tga sign_9.tga sign_bonus.tga sign_x10.tga sign_x11.tga sign_x12.tga sign_x2.tga sign_x3.tga sign_x4.tga sign_x5.tga sign_x6.tga sign_x7.tga sign_x8.tga sign_x9.tga
EXTRA_DIST = ${pkgdata_DATA}
mkinstalldirs = $(SHELL) $(top_srcdir)/mkinstalldirs
CONFIG_HEADER = ../src/config.h
CONFIG_CLEAN_FILES = 
DATA =  $(pkgdata_DATA)

DIST_COMMON =  Makefile.am Makefile.in


DISTFILES = $(DIST_COMMON) $(SOURCES) $(HEADERS) $(TEXINFOS) $(EXTRA_DIST)

TAR = gtar
GZIP_ENV = --best
all: all-redirect
.SUFFIXES:
$(srcdir)/Makefile.in: Makefile.am $(top_srcdir)/configure.in $(ACLOCAL_M4) 
	cd $(top_srcdir) && $(AUTOMAKE) --gnu --include-deps data/Makefile

Makefile: $(srcdir)/Makefile.in  $(top_builddir)/config.status
	cd $(top_builddir) \
	  && CONFIG_FILES=$(subdir)/$@ CONFIG_HEADERS= $(SHELL) ./config.status


install-pkgdataDATA: $(pkgdata_DATA)
	@$(NORMAL_INSTALL)
	$(mkinstalldirs) $(DESTDIR)$(pkgdatadir)
	@list='$(pkgdata_DATA)'; for p in $$list; do \
	  if test -f $(srcdir)/$$p; then \
	    echo " $(INSTALL_DATA) $(srcdir)/$$p $(DESTDIR)$(pkgdatadir)/$$p"; \
	    $(INSTALL_DATA) $(srcdir)/$$p $(DESTDIR)$(pkgdatadir)/$$p; \
	  else if test -f $$p; then \
	    echo " $(INSTALL_DATA) $$p $(DESTDIR)$(pkgdatadir)/$$p"; \
	    $(INSTALL_DATA) $$p $(DESTDIR)$(pkgdatadir)/$$p; \
	  fi; fi; \
	done

uninstall-pkgdataDATA:
	@$(NORMAL_UNINSTALL)
	list='$(pkgdata_DATA)'; for p in $$list; do \
	  rm -f $(DESTDIR)$(pkgdatadir)/$$p; \
	done
tags: TAGS
TAGS:


distdir = $(top_builddir)/$(PACKAGE)-$(VERSION)/$(subdir)

subdir = data

distdir: $(DISTFILES)
	@for file in $(DISTFILES); do \
	  d=$(srcdir); \
	  if test -d $$d/$$file; then \
	    cp -pr $$d/$$file $(distdir)/$$file; \
	  else \
	    test -f $(distdir)/$$file \
	    || ln $$d/$$file $(distdir)/$$file 2> /dev/null \
	    || cp -p $$d/$$file $(distdir)/$$file || :; \
	  fi; \
	done

info-am:
info: info-am
dvi-am:
dvi: dvi-am
check-am: all-am
check: check-am
installcheck-am:
installcheck: installcheck-am
install-exec-am:
install-exec: install-exec-am

install-data-am: install-pkgdataDATA
install-data: install-data-am

install-am: all-am
	@$(MAKE) $(AM_MAKEFLAGS) install-exec-am install-data-am
install: install-am
uninstall-am: uninstall-pkgdataDATA
uninstall: uninstall-am
all-am: Makefile $(DATA)
all-redirect: all-am
install-strip:
	$(MAKE) $(AM_MAKEFLAGS) AM_INSTALL_PROGRAM_FLAGS=-s install
installdirs:
	$(mkinstalldirs)  $(DESTDIR)$(pkgdatadir)


mostlyclean-generic:

clean-generic:

distclean-generic:
	-rm -f Makefile $(CONFIG_CLEAN_FILES)
	-rm -f config.cache config.log stamp-h stamp-h[0-9]*

maintainer-clean-generic:
mostlyclean-am:  mostlyclean-generic

mostlyclean: mostlyclean-am

clean-am:  clean-generic mostlyclean-am

clean: clean-am

distclean-am:  distclean-generic clean-am

distclean: distclean-am

maintainer-clean-am:  maintainer-clean-generic distclean-am
	@echo "This command is intended for maintainers to use;"
	@echo "it deletes files that may require special tools to rebuild."

maintainer-clean: maintainer-clean-am

.PHONY: uninstall-pkgdataDATA install-pkgdataDATA tags distdir info-am \
info dvi-am dvi check check-am installcheck-am installcheck \
install-exec-am install-exec install-data-am install-data install-am \
install uninstall-am uninstall all-redirect all-am all installdirs \
mostlyclean-generic distclean-generic clean-generic \
maintainer-clean-generic clean mostlyclean distclean maintainer-clean


# Tell versions [3.59,3.63) of GNU make to not export all variables.
# Otherwise a system limit (for SysV at least) may be exceeded.
.NOEXPORT:
