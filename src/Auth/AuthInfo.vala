namespace Tubie.AuthInfo {

    public class AuthInfo {

        const string access_token_key = "access_token";
        const string refresh_token_key = "refresh_token";
        const string expires_in_key = "expires_in";
        const string issued_key = "issued";

        string access_token;
        string refresh_token;
        int64? expires_in;
        int64? issued;
        
        public bool hasValidAccessToken() {
            var now = new DateTime.now_local().to_unix();
            var hasValid = access_token != null && now < (issued + expires_in);
            return hasValid;
        }

        void read() {
            access_token = GDriveSync.localMeta.get(access_token_key);
            refresh_token = GDriveSync.localMeta.get(refresh_token_key);
            var expires_in_string = GDriveSync.localMeta.get(expires_in_key);
            if (expires_in_string != null) {
                expires_in = int64.parse(expires_in_string);
            } else {
                expires_in = null;
            }
            var issued_string = GDriveSync.localMeta.get(issued_key);
            if (issued_string != null) {
                issued = int64.parse(issued_string);
            } else {
                issued = null;
            }
        }

        void persist() {
            GDriveSync.localMeta.set(access_token_key, access_token);
            GDriveSync.localMeta.set(refresh_token_key, refresh_token); 
            GDriveSync.localMeta.set(expires_in_key, expires_in.to_string());
            GDriveSync.localMeta.set(issued_key, issued.to_string());
        }

    }
}