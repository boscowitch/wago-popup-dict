## Process this file with automake to produce Makefile.in
## Created by Anjuta

SUBDIRS = src 

wago_popup_dictdocdir = ${prefix}/share/doc/wago-popup-dict
wago_popup_dictdoc_DATA = \
	README\
	ChangeLog


EXTRA_DIST = $(wago_popup_dictdoc_DATA)


# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(wago_popup_dictdocdir)


dictsdir = $(pkgdatadir)/dicts
dicts_DATA = dictionaries/edict.sqlite3 \
	dictionaries/wadoku.sqlite3
	
# The desktop files
desktopdir = $(datadir)/applications
desktop_DATA =data/wago_popup_dict.desktop

#the application icon
appicondir=$(datadir)/pixmaps
appicon_DATA=data/wagodict_icon.svg
