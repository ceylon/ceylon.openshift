import java.lang {
    System
}

"Contains information related to your OpenShift deployment"
shared object openshift {
    
    "Returns true if running on OpenShift"
    shared Boolean running => System.getenv("OPENSHIFT_APP_NAME") exists;

    "The name of your application"
    shared String name => require("OPENSHIFT_APP_NAME");

    "The public host name under which your application will be accessible"
    shared String dns => require("OPENSHIFT_APP_DNS");

    "Your application path"
    shared String repository => require("OPENSHIFT_REPO_DIR");

    "Return information about the given cartridge, where `cartridgeName` can be any cartridge type
     running on OpenShift, such as `ceylon`, `vertx` or other"
    shared Cartridge cartridge(String cartridgeName){
        object cart satisfies Cartridge {
            name => cartridgeName;
        }
        return cart;
    }

    "If you are running a Ceylon cartridge, this will contain information about it"
    shared Cartridge ceylon = cartridge("ceylon");

    "If you are running a Vertx cartridge, this will contain information about it"
    shared Cartridge vertx = cartridge("vertx");

    "Return information about the given database, where `dataBaseName` can be any database type
     running on OpenShift, such as `postgresql`, `mysql`, `mongodb` or other"
    shared DataBase dataBase(String dataBaseName){
        object db satisfies DataBase {
            name => outer.name;
            type => dataBaseName;
        }
        return db;
    }

    "If you are running a postgres database, this will contain information to connect to it"
    shared DataBase postgres = dataBase("postgresql");

    "If you are running a mysql database, this will contain information to connect to it"
    shared DataBase mysql = dataBase("mysql");

    "If you are running a mongodb database, this will contain information to connect to it"
    shared DataBase mongodb = dataBase("mongodb");
}

