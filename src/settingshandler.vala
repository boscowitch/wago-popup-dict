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
	
	public SettingsHandler(string main_data_dir) {
		settings_saved = false;

		//GLib.Environment.get_user_data_dir();
		//GLib.Environment.get_user_config_dir();
		
		//dictionaries_path  = Path.build_path(Path.DIR_SEPARATOR_S, user_data_dir, "wago-popup-dict","dicts");
		dictionaries_path  = Path.build_filename(main_data_dir, "dicts");

		//Default important directories 
		dictionaries_path =  Path.build_filename(main_data_dir,"dicts");
		ui_dir = Path.build_filename(main_data_dir, "ui");
		
		settings_file_path = Path.build_filename(main_data_dir,"wago.conf");

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

	public bool set_current_dict(string dictname) {
		List<FileInfo> dicts = list_dictionarys();
		
		foreach ( FileInfo dict in (List<FileInfo>) dicts ) {
			if(((FileInfo)dict).get_name().replace(".sqlite3","") == dictname) {
				current_dictionary_name = dict.get_name();
				current_dictionary_path = Path.build_filename(dictionaries_path, dict.get_name () );
				current_sqlitedict.open( current_dictionary_path );
				//stdout.printf ("\n\n %s \n", current_dictionary_path);
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
			
			settings_saved=true;
			return true;
		}
		else{
			//set defaults
			hide_timeout=5500;
			hide_on_mouse_move = true;

			List<FileInfo> dicts = list_dictionarys();
			current_dictionary_name = ((FileInfo) dicts.nth_data(0)).get_name();
			current_dictionary_path = Path.build_filename(dictionaries_path, ((FileInfo) dicts.nth_data(0)).get_name() );
			//dictionaries_path + Path.DIR_SEPARATOR_S + ((FileInfo) dicts.first()).get_name();
			
			settings_saved = false;
			return false;
		}
	}
	
	public bool load_file(string path) {
		settings_file_path = path;
		settings_file = new KeyFile();
		
		try {
			settings_file.load_from_file(settings_file_path, KeyFileFlags.KEEP_COMMENTS);
			settings_saved = true;
			return true;
		}
		catch (KeyFileError err) {
			settings_saved = false;
		}	
		catch (FileError err) {
			settings_saved = false;
		}
		 
		return false;
	}
	
	public bool save_settings() {
		if( settings_file != null)
		{
			try {
				if(!settings_saved)
					FileUtils.set_contents(settings_file_path, settings_file.to_data(null));
				return true;
			}
			/*catch (KeyFileError err) { handeled in FileError!
			}*/
			catch (FileError err) {
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
