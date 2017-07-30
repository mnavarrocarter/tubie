using Gtk;
using WebKit;

namespace Tubie.Auth {

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
        var webView = new WebView();

        // La pongo en la ventana
        window.add(webView);

        var uri = "https://accounts.google.com/o/oauth2/v2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube.upload&response_type=code&redirect_uri=urn:ietf:wg:oauth:2.0:oob&client_id=425815189298-pi0qokkl6maelt120ckei6dit6dt7dq8.apps.googleusercontent.com";

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

        webView.load_uri(uri);
        Gtk.main();
    }

    /**
     * Obtener un Access Token de Google API
     * Hace lo siguiente:
     * 1. Chequea si ya tiene una autenticación válida. Si la tiene, no hace nada.
     * 2. Lee el GConf, repite el paso 1.
     * 3. Refresca auth utilizando el refresh token si existe
     * 4. Hace un Full Auth
     **/
    public void authenticate() {
        message("Attempting authentication using Google OAuth 2.0");

        if (!AuthInfo.hasValidAccessToken()) {
            AuthInfo.read();
            if (!AuthInfo.hasValidAccessToken()) {
                if (AuthInfo.refresh_token != null) {
                    refreshToken();
                } else {
                    doFullAuth();
                }
            }
        }
    }

    Json.Object request(string params) {
        var session = new Soup.Session();
        var message = new Soup.Message("POST", "http://https://accounts.google.com/o/oauth2/token");
        message.set_request("application/x-www-form-urlencoded", Soup.MemoryUse.COPY, params.data);
        session.send_message(message);
        var data = (string) message.response_body.flatten().data;
        var parser = new Json.Parser();
        try {
            parser.load_from_data(data, -1);
        } catch (Error e) {
            critical(e.message);
        }
        var object = parser.get_root().get_object();
        return object;
    }

    void requestToken(string code) {
        debug("Attempting to get new access token from authorization code");

        var params = @"code=$(code)&";
        params += "client_id=425815189298-pi0qokkl6maelt120ckei6dit6dt7dq8.apps.googleusercontent.com&";
        params += "client_secret=wjZQcOogfigsK8Z6MficU9Rp&";
        params += "redirect_uri=urn:ietf:wg:oauth:2.0:oob&";
        params += "grant_type=authorization_code";

        var object = request(params);

        AuthInfo.access_token = object.get_string_member("access_token");
        AuthInfo.expires_in = object.get_int_member("expires_in");
        AuthInfo.refresh_token = object.get_string_member("refresh_token");
        AuthInfo.issued = new DateTime.now_local().to_unix();

        AuthInfo.persist();
    }

    void refreshToken() {
        debug("Attempting to use refresh token to get new access token");

        var params = "client_id=425815189298-pi0qokkl6maelt120ckei6dit6dt7dq8.apps.googleusercontent.com&";
        params += "client_secret=wjZQcOogfigsK8Z6MficU9Rp&";
        params += @"refresh_token=$(AuthInfo.refresh_token)&";
        params += "grant_type=refresh_token";

        var object = request(params);

        AuthInfo.access_token = object.get_string_member("access_token");
        AuthInfo.expires_in = object.get_int_member("expires_in");
        AuthInfo.issued = new DateTime.now_local().to_unix();

        AuthInfo.persist();
    }

}

