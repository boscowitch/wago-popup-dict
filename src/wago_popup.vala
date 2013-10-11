using Gtk;
using Gdk;


//TODO load settings from settings handler, maybe add notification derivation (new baseclass ?)

public class WagoPopup : Gtk.Window {
	public Clipboard clip_handler;
    public Gtk.Label label;
	private uint Timer;
	private SettingsHandler handler;
	
    private string clipboard_text;
    private string last_clipboard_text;
        
    private SqliteDictionary dict;

	
	public WagoPopup(SettingsHandler handler) {
		Object (type: Gtk.WindowType.POPUP);
		this.handler = handler;
		
	    //type = Gtk.WindowType.POPUP;
		
		dict = handler.get_current_dict();
		
		//base(WindowType.POPUP);
		skip_taskbar_hint = true;
		skip_pager_hint = true;
		can_focus = false;
		//for mouse click button-press-event
		add_events(Gdk.EventMask.BUTTON_PRESS_MASK);
		
		
		move(Gdk.Screen.width() - 310, Gdk.Screen.height() - 250);
		/*Gdk.Color color;
		Gdk.Color.parse("black", out color);*/

		border_width = 2;
		//TODO move to Settings ect.
		opacity = handler.get_notify_transparency();
		//set_opacity (opacity);

		Gdk.RGBA color = RGBA();
		color.parse("black");
		override_background_color( Gtk.StateFlags.NORMAL,color);
		
		
		set_default_size(300,-1);
		destroy.connect (Gtk.main_quit);
		label = new Label("");
		label.selectable = false;
		label.set_line_wrap(true);
		label.set_size_request(300,-1);

		Gdk.RGBA fg_color = RGBA();
		fg_color.parse("white");
		label.override_color(StateFlags.NORMAL, fg_color);
		label.show();
		add(label);

		
		Timer = Timeout.add( handler.get_hide_timeout() ,HideTimer);
		
		//Signal.connect(this, "button-press-event", (GLib.Callback) EnterWindow, null);
		//Signal.connect(this, "enter-notify-event", (GLib.Callback) EnterWindow, null);
		this.button_press_event.connect(EnterWindow);
		this.enter_notify_event.connect(EnterWindow);
	    	
	    last_clipboard_text = "";

	    
		//TODO when check for OS linux only!
	    clip_handler = Clipboard.get(Gdk.SELECTION_PRIMARY); 
		
		this.clip_handler.owner_change.connect(clipboard_changed);
	    //Signal.connect(clip_handler, "owner_change", (GLib.Callback) clipboard_changed ,this); !!! CRASH!
	}
	
	public void search_and_popup() {
		if(clipboard_text == last_clipboard_text)
			return;
		last_clipboard_text = clipboard_text;
		string jap,transl;
		if(!dict.search_jap_entry(clipboard_text,out jap,out transl))
			if(!dict.search_japstem_entry(clipboard_text,out jap,out transl))
				if(!dict.search_jap_like(clipboard_text,out jap,out transl))
					return;
		popup_text(jap,transl);
	}
	        
        public void clipboard_changed() {
	    	clipboard_text = clip_handler.wait_for_text();
	    	if(clipboard_text != null) {
	    		//TODO char check settings for language!
	    		if( (clipboard_text.get_char() >=  0x4E00 && clipboard_text.get_char() <= 0x9FAF) ||
	    		     (clipboard_text.get_char() >=  0x30A0  && clipboard_text.get_char() <= 0x30FF) ||
	    		     (clipboard_text.get_char() >= 0x3040 && clipboard_text.get_char() <= 0x309F)  )
	    			search_and_popup();
	    	}
    	}
    	  	
    	public void popup_text(string title, string text) {
    		string tmp = text;
			opacity = handler.get_notify_transparency();
    		tmp = tmp.replace("&","&amp");
    		tmp = tmp.replace("<","&#60;");
			tmp = tmp.replace(">","&#62;");

    		label.set_markup("<span font=\"Meiryo 14\">%s</span>\n%s".printf(title,tmp));
    		
    		//TODO settings handling position
    		int x_pos,y_pos;
	        //Gdk.ModifierType modif_type;
	        Gdk.Display displ = Gdk.Display.get_default();
	        Gdk.Screen scrn;// = displ.get_default_screen();
	        
	        //Deprecated
	      	//  displ.get_pointer(out scrn,out x_pos, out y_pos, out modif_type);
	        
	        Gdk.DeviceManager? devmgr = displ.get_device_manager();
	        Device dev = devmgr.get_client_pointer();
	        dev.get_position(out scrn, out x_pos, out y_pos);
	       	
	       	int sheight = scrn.get_height();
	       	int swidth = scrn.get_width();
	       	
	       	
	       	int wheight=0, wwidth=0;
	       	this.get_size(out wwidth, out wheight);
	       	
	       	if( (x_pos +  wwidth) > swidth )
	       		x_pos = x_pos - ((x_pos +  wwidth)-swidth);
	       	if( (y_pos + wheight) >= sheight )
	       		y_pos = y_pos - ( wheight + 50);
	        
	        resize(1,1);
	        move(x_pos,y_pos+30);
    		show();
    		
    		Source.remove(Timer);
    		
			Timer = Timeout.add(handler.get_hide_timeout(),HideTimer);
    	}
    	 
    	public void mouse_movement(Widget widget,Gdk.Event  event,void*   user_data) {
			if(handler.get_hide_on_mouse_move())
        		hide();
    	}
    	
    	public bool HideTimer() {
			hide();
			return false;
		}
    	
    	private bool EnterWindow() {
			if(handler.get_hide_on_mouse_move()) {
				hide();
				Source.remove(Timer);
			}
		return true;
		}
    	  	
}
