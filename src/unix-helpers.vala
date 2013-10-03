//using Posix;


public class Helpers {

        public static string getExecutableDirectory() {
           //	string exelink;
           	string Path;
        	char exepath[1024];
        //	exelink = "/proc/%d/exe".printf(Posix.getpid());
        
        	//Posix.readlink(exelink,exepath);
        	Path = (string)exepath;
        
        	Path = Path.slice(0,Path.last_index_of_char('/'));
        	return Path;
        }
        
}

