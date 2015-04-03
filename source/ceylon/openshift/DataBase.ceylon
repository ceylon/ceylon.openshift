"Represents an OpenShift DataBase"
shared interface DataBase {
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