using GLib;
using Gtk;

public class SettingsHandler : GLib.Object {
	
	private bool settings_saved;
	private KeyFile settings_file;
	
	private string settings_file_path;

	public string dictionaries_path;
	public string ui_dir;
	
	private string current_dictionary_path;
	private string current_dictionary_name;
	private SqliteDictionary current_sqlitedict; 

	
	private int hide_timeout;
	private bool hide_on_mouse_move;
	private double notify_transparency;
	
	public SettingsHandler(string main_data_dir) {
		settings_saved = false;

		//GLib.Environment.get_user_data_dir();
		//GLib.Environment.get_user_config_dir();
		settings_file_path = Path.build_filename (Path.DIR_SEPARATOR_S, GLib.Environment.get_user_config_dir() ,"wago_popup_dict", "wago.conf");

		DirUtils.create_with_parents ( Path.build_filename (Path.DIR_SEPARATOR_S, GLib.Environment.get_user_config_dir() ,"wago_popup_dict",Path.DIR_SEPARATOR_S),0766);
		
		
		settings_file = new KeyFile();
		settings_file.set_list_separator (';');
		
		
		//dictionaries_path  = Path.build_path(Path.DIR_SEPARATOR_S, user_data_dir, "wago-popup-dict","dicts");
		dictionaries_path  = Path.build_filename(main_data_dir, "dicts");

		//Default important directories 
		dictionaries_path =  Path.build_filename(main_data_dir,"dicts");
		ui_dir = Path.build_filename(main_data_dir, "ui");

		hide_timeout=0;
		notify_transparency = -1;
		load_default_settings();
		
		//stdout.printf ("\n %s \n", current_dictionary_path);
		current_sqlitedict = new SqliteDictionary.load(current_dictionary_path);
		//stdout.printf ("\n %s \n", current_dictionary_name); 
		//GLib.stderr.printf(dictionaries_path);
	}

	public string get_current_dict_name() {
		return current_dictionary_name;
	}

	public SqliteDictionary get_current_dict() {
		return current_sqlitedict;
	}

	public bool set_hide_timeout(int timeout) {
		hide_timeout = timeout;
		settings_saved = false;
		return true;
	}

	public bool set_hide_on_mouse_move(bool hide) {
		hide_on_mouse_move = hide;
		settings_saved = false;
		return true;
	}

	public double get_notify_transparency() {
		return notify_transparency;
	}

	public bool set_notify_transparency(double transparency) {
		notify_transparency = transparency;
		return true;
	}
	

	public bool set_current_dict(string dictname) {
		List<FileInfo> dicts = list_dictionarys();
		
		foreach ( FileInfo dict in (List<FileInfo>) dicts ) {
			if(((FileInfo)dict).get_name().replace(".sqlite3","") == dictname) {
				current_dictionary_name = dict.get_name();
				current_dictionary_path = Path.build_filename(dictionaries_path, dict.get_name () );
				current_sqlitedict.open( current_dictionary_path );
				settings_saved = false;
				return true;
			}
		}
		return false;
	}

	public string get_application_icon_path() {
		return Path.build_filename( ui_dir, "wago.png");
	}

	public int get_hide_timeout() {
		return hide_timeout;
	}

	public bool get_hide_on_mouse_move() {
		return hide_on_mouse_move;
	}
	
	public bool load_default_settings() {
		if(load_file(settings_file_path)) {
			if( File.new_for_path (current_dictionary_path).query_exists () ) {
				settings_saved=true;
				return true;
			}
		}
		
		if(hide_timeout == 0 || notify_transparency == -1) {
			hide_timeout=5500;
			hide_on_mouse_move = true;
			notify_transparency = 0.75;
		}
		List<FileInfo> dicts = list_dictionarys();
		current_dictionary_name = ((FileInfo) dicts.nth_data(0)).get_name();
		current_dictionary_path = Path.build_filename(dictionaries_path, ((FileInfo) dicts.nth_data(0)).get_name() );
		//dictionaries_path + Path.DIR_SEPARATOR_S + ((FileInfo) dicts.first()).get_name();
		settings_saved = false;
		return false;
	}
	
	public bool load_file(string path) {
		settings_file_path = path;
		settings_file = new KeyFile();
		
		try {
			settings_file.load_from_file(settings_file_path, KeyFileFlags.KEEP_COMMENTS);
			current_dictionary_path = settings_file.get_string ("wago-popup","Dictionary");
			File tmpdict = File.new_for_path (current_dictionary_path);
			current_dictionary_name = tmpdict.query_info ("*", FileQueryInfoFlags.NONE).get_name ();
			hide_on_mouse_move = settings_file.get_boolean ("wago-popup","hide-on-mouse-hover");
			hide_timeout = settings_file.get_integer ("wago-popup","hide-timeout");
			notify_transparency = settings_file.get_double ("wago-popup","notify_transparency");
			settings_saved = true;
			return true;
		}
		catch (Error err) {
			settings_saved = false;
		}
		 
		return false;
	}
	
	public bool save_settings() {
		if( settings_file != null)
		{
			try {
				if(!settings_saved) {
					settings_file.set_string ("wago-popup","Dictionary",current_dictionary_path);
					settings_file.set_boolean ("wago-popup","hide-on-mouse-hover",hide_on_mouse_move);
					settings_file.set_integer ("wago-popup","hide-timeout",hide_timeout);
					settings_file.set_double ("wago-popup","notify_transparency", notify_transparency);
					FileUtils.set_contents(settings_file_path, settings_file.to_data(null));
				}
				return true;
			}
			/*catch (KeyFileError err) { handeled in FileError!
			}*/
			catch (FileError e) {
				stdout.printf("Error: %s\n", e.message);
			}
		}
		return false;
	}
	
	public List<FileInfo> list_dictionarys() {
		List<FileInfo> dicts = new List<FileInfo> ();
		try {
			File dir = File.new_for_path(dictionaries_path);
			var enumerator = dir.enumerate_children(FileAttribute.STANDARD_NAME,0);
			FileInfo file_info;
			while((file_info = enumerator.next_file()) != null) {
				if(file_info.get_name().contains (".sqlite3"))
					dicts.append(file_info);
			}
		}
		catch (Error e) {
			//error
		}
		return dicts;
	}

}
