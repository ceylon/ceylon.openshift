import java.lang {
    System
}

"Represents an OpenShift Cartridge"
shared interface Cartridge {
    
    "Returns true if there is a cartridge of this type running"
    shared default Boolean running => System.getenv(environmentVariableName("IP")) exists;
    
    "The cartridge name"
    shared formal String name;
    
    "The IP you should bind to"
    shared String ip => require(environmentVariableName("IP"));
    
    "The port you should bind to"
    shared Integer port => requireInteger(environmentVariableName(name == "vertx" then "PORT" else "HTTP_PORT"));

    String environmentVariableName(String postfix){
        return "OPENSHIFT_``name.uppercased``_``postfix``";
    }
}