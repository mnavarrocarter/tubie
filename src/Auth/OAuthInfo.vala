namespace Auth {

    public class OAuthInfo {

        const string access_token_key = "access-token";
        const string refresh_token_key = "refresh-token";
        const string expires_in_key = "expires-in";
        const string issued_key = "issued";

        public static string access_token;
        public static string refresh_token;
        public static int64 expires_in;
        public static int64 issued;
        
        /**
         * Checks if there's a valid access token
         * @return {Boolean} [description]
         */
        public static bool hasValidAccessToken () {
            int64 now = new DateTime.now_local().to_unix();
            if (now - expires_in > issued) {
                return false;
            } else {
                return true;
            }
        }

        /**
         * Read auth data from app settings
         * @return {[type]} [description]
         */
        public static void read () {
            string homedir = GLib.Environment.get_home_dir();
            string filename = homedir + "/.config/Tubie/OAuthData.txt";
            var file = File.new_for_path(filename);

            if (!file.query_exists ()) {
                stderr.printf ("File '%s' doesn't exist.\n",
                        file.get_path ());
                return;
            }
            
            try {

                var dis = new DataInputStream (file.read ());
                string line;

                access_token = dis.read_line().split("=")[1];
                refresh_token = dis.read_line().split("=")[1];
                expires_in = int64.parse(dis.read_line().split("=")[1]);
                issued = int64.parse(dis.read_line().split("=")[1]);

            } catch (Error e) {
                error ("%s", e.message);
            }
        }

        /**
         * Saves auth data in app settings
         * @return {[type]} [description]
         */
        public static void persist () {
            string homedir = GLib.Environment.get_home_dir();
            string filename = homedir + "/.config/Tubie/OAuthData.txt";
            message("Writing %s....\n", filename);

            var file = File.new_for_path(filename);

            try {
                FileOutputStream fos =
                    file.replace(null, false, FileCreateFlags.NONE);
                DataOutputStream dos = new DataOutputStream(fos);
                dos.put_string(access_token_key + "=" + access_token + "\n");
                dos.put_string(refresh_token_key + "=" + refresh_token + "\n");
                dos.put_string(expires_in_key + "=" + expires_in.to_string () + "\n");
                dos.put_string(issued_key + "=" + issued.to_string () + "\n");
            } catch (Error e) {
                error ("%s", e.message);
            }
        }


    }
}