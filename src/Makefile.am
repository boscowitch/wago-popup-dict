## Process this file with automake to produce Makefile.in

## Created by Anjuta


uidir = $(pkgdatadir)/ui
ui_DATA = wago_popup_dict.ui \
	../data/wago.png \
	settings-dlg.ui


AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(WAGO_POPUP_DICT_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = wago_popup_dict

wago_popup_dict_SOURCES = \
	wago_popup_dict.vala config.vapi settingsdlg.vala settingshandler.vala sqlitedictionary.vala unix-helpers.vala wago_popup.vala wordstem.vala sqlite3.c sqlite3.h sqlite3fts.vapi wago.vala

wago_popup_dict_CFLAGS = -lpthread \
	-ldl 

wago_popup_dict_VALAFLAGS =  \
	--pkg gtk+-3.0

wago_popup_dict_LDFLAGS = \
	-Wl,--export-dynamic,

wago_popup_dict_LDADD = $(WAGO_POPUP_DICT_LIBS)


EXTRA_DIST = $(ui_DATA)

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)

