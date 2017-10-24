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
            
        }

        /**
         * Saves auth data in app settings
         * @return {[type]} [description]
         */
        public static void persist () {
               
        }


    }
}