/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * main.c
 * Copyright (C) 2013 Pascal Schnurr aka boscowitch <boscowitch@boscowitch.de>
 * 
 * wago-popup-dict is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * wago-popup-dict is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using GLib;
using Gtk;

public class Main : Object 
{

	const string MAIN_DIR = Config.PACKAGE_DATA_DIR;
	public static SettingsHandler handler;
	
	public Main ()
	{
/*
		try 
		{
			var builder = new Builder ();
			builder.add_from_file (UI_FILE);
			builder.connect_signals (this);

			var window = builder.get_object ("window") as Window;
			
			window.show_all ();
		} 
		catch (Error e) {
			stderr.printf ("Could not load UI: %s\n", e.message);
		} 
*/
	}
/*
	[CCode (instance_pos = -1)]
	public void on_destroy (Widget window) 
	{
		
		
		Gtk.main_quit();
	}
*/
	static int main (string[] args) 
	{
		Gtk.init (ref args);

		handler = new SettingsHandler(MAIN_DIR);
		
	    Wago app = new Wago(handler);
	    app.popup = new WagoPopup(handler);	

		Gtk.main ();
		handler.save_settings ();
		
		return 0;
	}
}

