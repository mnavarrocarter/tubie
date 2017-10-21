namespace Tubie.Core {

    public class Database : GLib.Object {

        /**
         * variables
         */
        private Gda.Connection   connection;
        public string           provider;
        public string           data_dir;
        public string           dir_path;
        public File             database_dir;
        public string           hostname;

        /**
         * Constructor
         */
        public Database () {
            try {
                this.provider     = "SQLite";
                this.data_dir     = Environment.get_user_data_dir ();
                this.dir_path     = Path.build_path (Path.DIR_SEPARATOR_S, data_dir, "karim");
                this.database_dir = File.new_for_path (dir_path);
                this.hostname     = "DB_DIR=%s;DB_NAME=%s".printf (database_dir.get_path (), "karim");
                check_dir ();
                create_database ();
                create_connection ();
                create_table_downloads ();
            } catch (Error e) {
                critical (e.message);
            }
        }

        /**
         * Get connection.
         * 
         * @return {@code Connection}
         */
        public Gda.Connection get_connection () {
            return connection;
        }

        /**
         * Check directory.
         * 
         * @return void
         */
        private void check_dir () {
            try {
                this.database_dir.make_directory_with_parents (null);
            } catch (Error err) {
                if (err is IOError.EXISTS == false) {
                    error (err.message);
                }
            }
        }

        /**
         * Create database if it does not exist.
         * 
         * @return void
         */
        private void create_database () {
            var db_file = this.database_dir.get_child ("karim.db");
            bool new_db = !db_file.query_exists ();

            if (new_db) {
                try {
                    db_file.create (FileCreateFlags.PRIVATE);
                } catch (Error e) {
                    critical (e.message);
                }
            }
        }

        /**
         * Initiate connection with data bank
         * 
         * @return void
         */
        private void create_connection () {
            try {
                this.connection = Gda.Connection.open_from_string (
                    this.provider,
                    this.hostname,
                    null,
                    Gda.ConnectionOptions.NONE
                );
            } catch (Error e) {
                error (e.message);
            }
        }

        /**
         * Create table downloads if it does not exist
         * 
         * @return void
         */
        private void create_table_downloads () throws Error requires (this.connection.is_opened()) {
            Error e = null;
            var operation = Gda.ServerOperation.prepare_create_table (
                connection, "downloads", e,
                "id",         typeof (int),    Gda.ServerOperationCreateTableFlag.PKEY_AUTOINC_FLAG,
                "name",       typeof (string), Gda.ServerOperationCreateTableFlag.NOTHING_FLAG,
                "url",        typeof (string), Gda.ServerOperationCreateTableFlag.NOTHING_FLAG,
                "progress",   typeof (double), Gda.ServerOperationCreateTableFlag.NOTHING_FLAG,
                "percentage", typeof (int),    Gda.ServerOperationCreateTableFlag.NOTHING_FLAG
            );

            if (e != null) {
                critical (e.message);
            } else {
                try {
                    operation.perform_create_table ();
                } catch (Error e) {
                    GLib.message (e.message);
                }
            }
        }
    }
}