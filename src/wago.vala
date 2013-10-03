using Gtk;

public class Wago : GLib.Object {
	private StatusIcon trayicon;
	private Gtk.Menu menuSystem;
	private AboutDialog about;
	private SettingsDlg setdlg;
	private SettingsHandler handler;
	
	public WagoPopup popup;
	
	public Wago(SettingsHandler handler) {

		this.handler = handler;
		setdlg = new SettingsDlg(handler); 

		trayicon = new StatusIcon.from_file( handler.get_application_icon_path() );
     	trayicon.set_tooltip_text ("Wago-Popup Tray");
     	trayicon.set_visible(true);
		trayicon.activate.connect(about_clicked);
		
      	create_menuSystem();
    	trayicon.popup_menu.connect(menuSystem_popup);
    		 
    	about = new AboutDialog();
    	about.set_version("1.0.0");
     	about.set_program_name("Wago-Popup-Dict");
     	about.set_comments("Wago-Popup is an opensource Japanse Dictionary popup tool.\n licensed under the GPL v3");
    	about.set_copyright("Copyright 2012 by boscowitch");
    	about.set_website("http://www.boscowitch.de");
    	about.set_logo(trayicon.get_pixbuf());
    	about.set_modal(true);
		
    	//about.set_has_frame(true);	
	}
	
	private void about_clicked() {
		about.run();
		about.hide();
   	}
   	 
   	 private void on_settings() {
   	 	setdlg.run();
   	 }
	/* Show popup menu on right button */
    private void menuSystem_popup(uint button, uint time) {
		menuSystem.popup(null, null, null, button, time);
    }
    
	 /* Create menu for right button */
    public void create_menuSystem() {
		menuSystem = new Gtk.Menu();
      
  		var menuAbout = new ImageMenuItem.from_stock(Stock.ABOUT, null);
 		menuAbout.activate.connect(about_clicked);
 	    menuSystem.append(menuAbout);
      
  		var menuSettings = new ImageMenuItem.from_stock(Stock.PREFERENCES,null);
 	    menuSettings.activate.connect(on_settings);
 	    menuSystem.append(menuSettings);
      
  		var menuQuit = new ImageMenuItem.from_stock(Stock.QUIT, null);
  		menuQuit.activate.connect(Gtk.main_quit);
 	    menuSystem.append(menuQuit);
        
  		menuSystem.show_all();
    }
	

}
