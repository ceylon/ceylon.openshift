import java.lang {
    System
}

"Contains information related to your OpenShift deployment"
shared object openshift {
    
    "Returns true if running on OpenShift"
    shared Boolean running => System.getenv("OPENSHIFT_APP_NAME") exists;

    String require(String name){
        assert(exists val = System.getenv(name));
        return val;
    }

    Integer requireInteger(String name){
        value p = require(name);
        assert(exists parsed = parseInteger(p));
        return parsed;
    }

    "The name of your application"
    shared String name => require("OPENSHIFT_APP_NAME");

    "The IP you should bind to"
    shared String ip => require("OPENSHIFT_CEYLON_IP");

    "The port you should bind to"
    shared Integer port => requireInteger("OPENSHIFT_CEYLON_HTTP_PORT");

    "The public host name under which your application will be accessible"
    shared String dns => require("OPENSHIFT_APP_DNS");

    "Your application path"
    shared String repository => require("OPENSHIFT_REPO_DIR");

    "If you are running a postgres dagtabase, this will contain information to connect to it"
    shared object postgres satisfies DataBase {
        host => require("OPENSHIFT_POSTGRESQL_DB_HOST");
        port => requireInteger("OPENSHIFT_POSTGRESQL_DB_PORT");
        user => require("OPENSHIFT_POSTGRESQL_DB_USERNAME");
        password => require("OPENSHIFT_POSTGRESQL_DB_PASSWORD");
        name => outer.name;
        jdbcUrl => "jdbc:postgresql://``host``:``port``/``name``";
    }
}

