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

namespace Tubie {

    public static void main (string [] args) {
        // Se inicializa Gtk con los argumentos
        Gtk.init (ref args);
        if (args.length <= 1) {
            warning("You must select a file to upload");
        } else {
            // Se instancia la clase UploadWindow con la ruta del archivo como parámetro
            var file = File.new_for_path (args[1]);
            var dialog = new UploadWindow();
            dialog.Uploader(file);
            dialog.show_all ();
            Gtk.main ();
        }
    }

}