namespace Auth {

    public class OAuth {

        public OAuth () {
            message("Attempting authentication using Google OAuth 2.0");
            if (!OAuthInfo.hasValidAccessToken()) {
                OAuthInfo.read();
                if (!OAuthInfo.hasValidAccessToken()) {
                    if (OAuthInfo.refresh_token != null) {
                        refreshToken();
                    } else {
                        // Antes del Full Auth hay que verificar auth code
                        doFullAuth();
                    }
                }
            }
        }

        /**
         * Autoriza la aplicación por primera vez con OAuth
         * Hace lo siguiente:
         * 1. Crea la vista de WebView
         * 2. Chequea cada evento de carga terminada por un access code.
         * 3. Solicita un token
         */
        void doFullAuth() {
            unowned string[] args = null;
            Gtk.init(ref args);
            
            // Creo la ventana
            var window = new Gtk.Window(Gtk.WindowType.TOPLEVEL);
            window.set_default_size(900,800);
            window.set_position(Gtk.WindowPosition.CENTER);
            window.title = "Tubie Authorization";
            window.destroy.connect(Gtk.main_quit);
            // Creo la vista web
            var webView = new WebKit.WebView();
            // La pongo en la ventana
            window.add(webView);

            var url = "https://accounts.google.com/o/oauth2/v2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube.upload&response_type=code&redirect_uri=urn:ietf:wg:oauth:2.0:oob&client_id=425815189298-pi0qokkl6maelt120ckei6dit6dt7dq8.apps.googleusercontent.com";

            webView.load_changed.connect( (webView, WEBKIT_LOAD_FINISHED) => {
                var title = webView.get_title();
                if (title != null) {
                    var split = title.split("=");
                    if (split.length == 2 && split[0] == "Success code") {
                        var code = split[1];
                        window.destroy();
                        requestToken(code);
                    }
                }
            });

            webView.show();
            window.show();

            webView.load_uri(url);
            Gtk.main();
        }

        /**
         * Solicita un nuevo token desde Google OAuth
         * @param  string code
         */
        void requestToken(string code) {
            message(@"Attempting to get new access token using authorization code: $(code)");

            var params = @"code=$(code)&";
            params += "client_id=425815189298-pi0qokkl6maelt120ckei6dit6dt7dq8.apps.googleusercontent.com&";
            params += "client_secret=wjZQcOogfigsK8Z6MficU9Rp&";
            params += "redirect_uri=urn:ietf:wg:oauth:2.0:oob&";
            params += "grant_type=authorization_code";

            var request = new Request();
            Json.Object data = request.post("https://www.googleapis.com/oauth2/v4/token", params);

            OAuthInfo.access_token = data.get_string_member("access_token");
            OAuthInfo.expires_in = data.get_int_member("expires_in");
            OAuthInfo.refresh_token = data.get_string_member("refresh_token");
            OAuthInfo.issued = new DateTime.now_local().to_unix();

            OAuthInfo.persist();
        }

        /**
         * Obtiene un nuevo token utilizando el Refresh Token.
         */
        void refreshToken() {
            debug("Attempting to use refresh token to get new access token");

            var params = "client_id=425815189298-pi0qokkl6maelt120ckei6dit6dt7dq8.apps.googleusercontent.com&";
            params += "client_secret=wjZQcOogfigsK8Z6MficU9Rp&";
            params += @"refresh_token=$(OAuthInfo.refresh_token)&";
            params += "grant_type=refresh_token";

            var request = new Request();
            Json.Object data = request.post("https://www.googleapis.com/oauth2/v4/token", params);

            OAuthInfo.access_token = data.get_string_member("access_token");
            OAuthInfo.expires_in = data.get_int_member("expires_in");
            OAuthInfo.issued = new DateTime.now_local().to_unix();

            OAuthInfo.persist();
        }
        
    }
}
