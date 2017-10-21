namespace Tubie.Auth {

    public class Secrets {

        /**
         * Schema property
         * @type ref
         */
        public ref schema = new Secret.Schema ("com.github.navarrocarter.tubie", Secret.SchemaFlags.NONE,
            "name", Secret.SchemaAttributeType.STRING
        );

        /**
         * Saves a key into the secret service
         */
        bool store(string name, string value) {
            var att = new GLib.HashTable<string,string> ();
            att["name"] = name;

            Secret.password_storev.begin (this.schema, att, Secret.COLLECTION_DEFAULT,
                "Google OAuth Key", value, null, (obj, async_res) => {
                    bool res = Secret.password_store.end (async_res);
                    return res;
                }
            );
        }

        /**
         * Gets a key from the secret service and returns it's value
         */
        string get(string name) {
            
        }
    }

}