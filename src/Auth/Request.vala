namespace Auth {

    class Request {

        private Soup.Session session;
        private Soup.Message message;
        private string method;
        private string url;
        private string params;

        public Request () {
            session = new Soup.Session();
        }

        public Json.Object post (string url, string params) {
            debug("Preparing the POST request");
            message = new Soup.Message ("POST", url);
            message.set_request("application/x-www-form-urlencoded", Soup.MemoryUse.STATIC, params.data);
            return doRequest();
        }

        private Json.Object doRequest () {
            debug("Performing the request");
            session.send_message(message);
            var data = (string) message.response_body.flatten().data;
            return parse(data);
        }

        private Json.Object parse (string data) {
            debug("Parsing the request into Json");
            var parser = new Json.Parser ();
            try {
                parser.load_from_data(data, -1);
            } catch (Error e) {
                critical(e.message);
            }
            var obj = parser.get_root().get_object();
            return obj;
        }

    }

}