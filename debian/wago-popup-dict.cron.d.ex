#
# Regular cron jobs for the wago-popup-dict package
#
0 4	* * *	root	[ -x /usr/bin/wago-popup-dict_maintenance ] && /usr/bin/wago-popup-dict_maintenance
