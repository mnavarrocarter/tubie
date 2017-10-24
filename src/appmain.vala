/*
* Copyright (c) 2017 Matias Navarro Carter (https://navarrocarter.com)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
*/

/*
 |-------------------------------------------------------------------------
 | Constructor Función Principal
 |-------------------------------------------------------------------------
 | Aqui se pone la función principal de la aplicación. Esto hace funcionar 
 | todo.
 |
 */

public class Tubie : Gtk.Application {

    public File file;

    public Tubie () {
        Object (application_id: "com.github.mnavarrocarter.tubie",
        flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate () {
        var upload_window = new Views.UploadWindow (this);
        upload_window.uploader(file);
        upload_window.show ();
    }

    public static int main (string[] args) {
        if (args.length <= 1) {
            warning("You must select a file to upload");
        } else {
            file = File.new_for_path (args[1]);
            return new Tubie ().run ();
        }
    }
}