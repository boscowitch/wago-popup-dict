using Gtk;
using SqliteFTS; // own modded vapi file needs to be given at compile time!
//using Sqlite;  //needs to be uncommented not working with FTS, only for testing!

public class SqliteDictionary {
      
        private Database db; 
        private int ret_val;
        private bool db_loaded;
        
        public SqliteDictionary() {
                db_loaded = false;
        }
        
        public SqliteDictionary.load(string path_to_database) {
                 open(path_to_database);
        }
        
        public bool is_opened()  {
        	return db_loaded;       	
        }
        
        public bool open(string path_to_database) {
                if(db_loaded)
                        db.close();
                ret_val = Database.open_v2(path_to_database,out db, OPEN_READONLY);
                 if(ret_val > 0) 
                        db_loaded = false;
                 else
                        db_loaded = true;
                        
                 return db_loaded;
        }
        
        public bool cache_db_in_ram() {
                Database tmp;   
                if(db_loaded) {
                        if(  0 == Database.open(":memory:",out tmp) ) {
                                if( 0 == copy_whole_database(db,tmp) ) {
                                        db.close();
                                        db = (owned) tmp;    
                                        return true;
                                }
                        }
                        
                }
                return false;
        }
        
        
        private Statement stm;
        
        public bool search_jap_entry(string search, out string japanese, out string translation) {
                const string sql = "select reading,translation from dict where reading match ? order by docid asc limit 1";
                db.prepare_v2(sql,sql.length,out stm);
                stm.bind_text(1,search);
                if( ROW == stm.step()) {
                        japanese = stm.column_text(0);
                        translation = stm.column_text(1);
                        stm.reset();
                        return true;
                }
                japanese = translation = "";
                return false;
        }
        
        public bool search_japstem_entry(string search,  out string japanese, out string translation) {
                string stem = Wordstem.find_stem_form(search);
                if( stem != "") {
                        return search_jap_entry(stem,out japanese,out translation);
                }
                japanese = translation = "";
                return false;
        }
        
        public bool search_jap_like(string search, out string japanese, out string translation) {
                const string sql = "select c0reading,c1translation from dict_content where c0reading like ? order by docid asc limit 1";
                db.prepare_v2(sql,sql.length,out stm);
                stm.bind_text(1,"%" + search + "%");
                if( ROW == stm.step()) {
                        japanese = stm.column_text(0);
                        translation = stm.column_text(1);
                        stm.reset();
                        return true;
                }
                japanese = translation = "";
                return false;
        }
        
        public bool search_translation_entry(string search, out string japanese, out string translation) {
                const string sql = "select reading,translation from dict where translation match ? order by docid asc limit 1";
                db.prepare_v2(sql,sql.length,out stm);
                stm.bind_text(1,search);
                if( ROW == stm.step()) {
                        japanese = stm.column_text(0);
                        translation = stm.column_text(1);
 
                        stm.reset();
                        return true;
                }
                japanese = translation = "";
                return false;
        }
        
        public bool search_translation_like(string search, out string japanese, out string translation) {
                const string sql = "select c0reading,c1translation from dict_content where translation like ? order by docid asc limit 1";
                db.prepare_v2(sql,sql.length,out stm);
                stm.bind_text(1,"%" + search + "%");
                if( ROW == stm.step()) {
                        japanese = stm.column_text(0);
                        translation = stm.column_text(1);
 
                        stm.reset();
                        return true;
                }
                japanese = translation = "";
                return false;
        }
        
        
        public string[]? search_jap_page(string search, int limit,int start = 0) {
                
                string sql = "select reading,translation from dict where reading match ? order by docid asc limit %d,%d".printf(start, limit);
                db.prepare_v2( sql  ,sql.length,out stm);
                stm.bind_text(1,search);
                if( ROW != stm.step() )
                        return null;

                string[] results = new string[(stm.column_count()*2)];
                int i = 0;
                do {
                        results[i] = stm.column_text(0);
                        i++;
                        results[i] = stm.column_text(1);
                        i++;
                } while ( ROW == stm.step());
                
                stm.reset();
                return results;
        }
        
        
        
        
        
        //helper function
        private int copy_whole_database(Database source,Database dest) {
                Backup bak = new  Backup(dest,"main",source,"main");
                bak.step(-1);
                return dest.errcode();
        }


}
