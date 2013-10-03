using Gtk;

public class SettingsDlg : GLib.Object {
	private Dialog main_dlg;
	private Builder builder;
	private ComboBoxText dictcombo;
	private ComboBoxText positioncombo;
	private SettingsHandler handler;
	
	public SettingsDlg(SettingsHandler handler) {
		this.handler = handler;
		
		builder = new Builder();
		
		//TODO get path (settingshandler ect)S
		try {
		builder.add_from_file(  Path.build_filename(handler.ui_dir, "settings-dlg.ui") );
		}
		catch (GLib.Error err) {
		//TODO ERROR MSG
		}
		
		main_dlg = builder.get_object("dialog1") as Dialog;
		
		dictcombo = builder.get_object("dictcombo") as ComboBoxText;
		positioncombo = builder.get_object("positioncombo") as ComboBoxText;
		
		//main_dlg.set_modal(true);
		
		builder.connect_signals(this);

		List<FileInfo> dicts = handler.list_dictionarys();
		//TODO load all stuff into controls
		int i =0;
		foreach ( FileInfo dict in (List<FileInfo>) dicts ) {
			dictcombo.append_text( dict.get_name().replace (".sqlite3",""));
			if(handler.get_current_dict_name() == dict.get_name() ) {
				dictcombo.set_active(i);
			}
			i++;
		}

		
		
	}
	
	public void run() {
		main_dlg.show_all();
		main_dlg.show();
	}
	
	[CCode (instance_pos = -1)]
	public void on_save(Button source) {
		handler.set_current_dict(dictcombo.get_active_text());
		main_dlg.hide ();
	}
	
	[CCode (instance_pos = -1)]
	public void on_cancel(Button source) {
		main_dlg.hide ();
	}
}
