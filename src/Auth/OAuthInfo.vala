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
        public static Settings settings;
        
        /**
         * Checks if there's a valid access token
         * @return {Boolean} [description]
         */
        public static bool hasValidAccessToken () {
            return false;
        }

        /**
         * Read auth data from app settings
         * @return {[type]} [description]
         */
        public static void read () {
            message("Reading credentials");
            read_settings();
            access_token = settings.get_string(access_token_key);
            refresh_token = settings.get_string(refresh_token_key);
        }

        /**
         * Saves auth data in app settings
         * @return {[type]} [description]
         */
        public static void persist () {
            message("Storing credentials in file");
            read_settings ();
            settings.set_string(access_token_key, access_token);
            settings.set_string(refresh_token_key, refresh_token);
            //settings.set_int64(expires_in_key, expires_in);
            //settings.set_int64(issued_key, issued);
        }

        public static void read_settings () {
            SettingsSchemaSource sss = new SettingsSchemaSource.from_directory ("data/", null, false);
            SettingsSchema schema = sss.lookup ("com.github.mnavarrocarter.tubie", false);
            if (sss.lookup == null) {
                stdout.printf ("ID not found.");
            }
            settings = new Settings.full (schema, null, null);
        }

    }
}