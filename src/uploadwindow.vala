using Gtk;
using WebKit;

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

        webView.load_status.connect( (webView, WEBKIT_LOAD_FINISHED) => {
            var title = webView.get_title();
            if (title != null) {
                var split = title.split("=");
                if (split.length == 2 && split[0] == "Success code") {
                    var code = split[1];
                    window.destroy();
                    message(code);
                }
            }
        });

        webView.show();
        window.show();

        webView.load_uri(uri);
        Gtk.main();