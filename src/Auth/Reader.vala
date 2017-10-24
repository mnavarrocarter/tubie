/*string homedir = GLib.Environment.get_home_dir();
        
        string filename = homedir + "/.config/Tubie/OAuthData.txt";
        stdout.printf("Reading %s...\n", filename);

        var file = File.new_for_path(filename);

        if (!file.query_exists ()) {
            stderr.printf ("File '%s' doesn't exist.\n",
                    file.get_path ());
            return 1;
        }

        var map = new Gee.HashMap<string, string> (); 
        
        try {

            var dis = new DataInputStream (file.read ());
            string line;

            while ((line = dis.read_line (null)) != null) {
                var arr = line.split("=");
                map.set (arr[0], arr[1]);
            }
        } catch (Error e) {
            error ("%s", e.message);
        }

        var iterator = map.map_iterator();

        while (iterator.next()) {
            stdout.printf("%s => %s \n", iterator.get_key(), iterator.get_value());
        }
        
        return 0;
    }*/