"Represents an OpenShift DataBase"
shared interface DataBase {
    "Returns true if there is a database of this type running"
    shared formal Boolean running;
    "A URL suitable for connection over JDBC. Contains the host, port and database name"
    shared formal String jdbcUrl;
    "The database name"
    shared formal String name;
    "The database user name"
    shared formal String user;
    "The database password"
    shared formal String password;
    "The database port"
    shared formal Integer port;
    "The database host name"
    shared formal String host;
}