namespace Tubie.Views {

    public class UploadWindow : Gtk.Window {

        class LLabel : Gtk.Label {
            
            public LLabel (string label) {
                this.set_halign (Gtk.Align.START);
                this.label = label;
            }

            public LLabel.indent (string label) {
                this (label);
                this.margin_left = 10;
            }

            public LLabel.markup (string label) {
                this (label);
                this.use_markup = true;
            }

            public LLabel.right (string label) {
                this.set_halign (Gtk.Align.END);
                this.label = label;
            }

            public LLabel.right_with_markup (string label) {
                this.set_halign (Gtk.Align.END);
                this.use_markup = true;
                this.label = label;
            }
        }

        public void Uploader (File file) {
            this.title = "Upload to YouTube";
            this.set_default_size (300, -1);
            this.window_position = Gtk.WindowPosition.CENTER;

            var grid = new Gtk.Grid ();
            grid.margin = 12;
            grid.column_spacing = 12;
            grid.row_spacing = 5;

            var title = new Gtk.Entry ();

            var description = new Gtk.Entry ();
            description.placeholder_text = "Optional";

            var email = new Gtk.Entry ();

            var img = new Gtk.Image.from_icon_name ("video", Gtk.IconSize.DIALOG);

            var upload_button = new Gtk.Button.with_label ("Upload");
            upload_button.get_style_context ().add_class ("suggested-action");

            var cancel = new Gtk.Button.from_stock (Gtk.Stock.CANCEL);
            cancel.margin_end = 6;

            var bbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            bbox.pack_end (upload_button, false, true, 0);
            bbox.pack_end (cancel, false, true, 0);

            email.set_tooltip_text ("Your email address for connecting to your YouTube account");

            upload_button.image = new Gtk.Image.from_icon_name ("mail-reply-sender", Gtk.IconSize.BUTTON);
            upload_button.can_default = true;

            this.set_default (upload_button);

            grid.attach (img, 0, 0, 1, 2);
            grid.attach (new LLabel ("Title"), 1, 0, 1, 1);
            grid.attach (title, 2, 0, 1, 1);
            grid.attach (new LLabel ("Email"), 1, 1, 1, 1);
            grid.attach (email, 2, 1, 1, 1);
            grid.attach (new LLabel ("Description"), 1, 2, 1, 1);
            grid.attach (description, 2, 2, 1, 1);
            grid.attach (bbox, 0, 3, 3, 1);

            this.add (grid);
            this.destroy.connect (Gtk.main_quit);

            cancel.clicked.connect (Gtk.main_quit);

            upload_button.clicked.connect (() => {

    			// YouTube check if access token is valid
                var auth = new Auth();
                auth.authorize_app();            
    			// If not, request a new one.

    			// If it is, make the API Call

                Gtk.main_quit();
            });
        }
        
    }
}
