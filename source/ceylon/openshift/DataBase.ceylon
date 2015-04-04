import java.lang {
    System
}
"Represents an OpenShift DataBase"
shared interface DataBase {
    
    "Returns true if there is a database of this type running"
    shared default Boolean running => System.getenv(environmentVariableName("HOST")) exists;
    
    "A URL suitable for connection over JDBC. Contains the host, port and database name"
    shared default String jdbcUrl => "jdbc:``type.lowercased``://``host``:``port``/``name``";
    
    "The database name"
    shared formal String name;
    
    "The database user name"
    shared default String user => require(environmentVariableName("USERNAME"));
    
    "The database password"
    shared default String password => require(environmentVariableName("PASSWORD"));
    
    "The database port"
    shared default Integer port => requireInteger(environmentVariableName("PORT"));
    
    "The database host name"
    shared default String host => require(environmentVariableName("HOST"));
    
    "Returns the type of database, for example `postgres`"
    shared formal String type;

    String environmentVariableName(String postfix){
        return "OPENSHIFT_``type.uppercased``_DB_``postfix``";
    }
}